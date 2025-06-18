import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/helpers/loading/loading_dialog.dart';
import 'package:mynotes/helpers/searching/search_dialog.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_event.dart' hide InitializeEvent;
import 'package:mynotes/service/cloud/bloc/cloud_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_events.dart';
import 'package:mynotes/service/cloud/bloc/cloud_state.dart';
import 'package:mynotes/service/cloud/firebase_cloud_service.dart';
import 'package:mynotes/utilities/dialogs.dart';
import 'package:mynotes/views/note_editor_view.dart';
import 'package:mynotes/views/notes_list_view.dart';

class NotesView extends StatefulWidget 
{
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> 
{
 
  @override
  Widget build(BuildContext context) 
  {
    context.read<CloudBloc>().add(InitializeEvent());
    
    return BlocConsumer<CloudBloc, CloudState>(
      listener: (context, state) 
      {
        if (state.isLoading)
          LoadingDialog.instance.show(context, state.loadingText);
        else
          LoadingDialog.instance.hide();

        if (state is NotesListViewState)
          if (state.isSearching)
            SearchDialog.instance.showDialog(context, context.read<CloudBloc>());
      },
      builder: (context, state) {
        if (state is NotesListViewState)
          return buildInterface(context);
        if (state is NoteEditorState)
          return NoteEditorView(state.note);
        
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    );
  }
  

  Widget buildInterface(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text("Notes View", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        actions: 
        [
          IconButton
          (
            onPressed: () async
            {
              context.read<CloudBloc>().add(AddNoteEvent());
            }, 
            icon: Icon(Icons.add)
          ),
          PopupMenuButton
          (
            onSelected: (selection) async
            {
              switch (selection)
              {
                case 1:
                  if ((await showLogoutDialog(context)) == true)
                    context.read<AuthBloc>().add(LogoutEvent());
                  return;

                case 2:
                  context.read<CloudBloc>().add(SearchNoteEvent());
                  return;
              }
            },
            itemBuilder: (context) 
            {
              return 
              [
                PopupMenuItem
                (
                  value: 1, 
                  child: Text('logout')
                ),
                PopupMenuItem
                (
                  value: 2,
                  child: Text('search')
                ),
              ];
            },
          )
        ],
      ),
      body: StreamBuilder
      (
        stream: FirebaseCloudStorage.instance.controller.stream,
        builder: (context, snapshot) 
        {
          switch (snapshot.connectionState)
          {
            case ConnectionState.active:
            case ConnectionState.waiting:
              if (snapshot.hasData)
                return NotesListView
                (
                  notes: snapshot.data!, 
                  deleteCallback: (note) async
                  {
                    await FirebaseCloudStorage.instance.deleteNote(noteId: note.id);
                  },
                  openNoteCallback: (note)
                  {
                    // Navigator.pushNamed(context, '/add_note/', arguments: note);
                    context.read<CloudBloc>().add(OpenNoteEvent(noteId: note.id));

                  },
                );
              else
                return Center(
                  child: Text("Couldn't Fetch Your Notes")
                );

            default:
              return Column
              (
                children: 
                [
                  Text('Fetching Your Notes'),
                  CircularProgressIndicator()
                ],
              );
          }
        }
      ) 
    );
  }
}