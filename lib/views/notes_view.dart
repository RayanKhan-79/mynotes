
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/bloc/auth_bloc.dart';
import 'package:mynotes/service/bloc/auth_event.dart';
import 'package:mynotes/service/cloud/firebase_cloud_service.dart';
import 'package:mynotes/utilities/dialogs.dart';
import 'package:mynotes/views/notes_list_view.dart';

class NotesView extends StatefulWidget 
{
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> 
{
  String? selected;

  @override
  void initState() 
  {
    super.initState();
    FirebaseCloudStorage.instance.initializeListener(
      userId: AuthService.firebase().currentUser!.userId
    );
  }

  @override
  Widget build(BuildContext context) 
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
              Navigator.pushNamed(context, '/add_note/');
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
                  {
                    context.read<AuthBloc>().add(LogoutEvent());
                  }
                  return;
                case 2:
                  final c = searchDialog(context);
                  c.stream.listen(
                    (data)
                    {
                      FirebaseCloudStorage.instance.searchNotes(
                        string: data, 
                        userId: AuthService.firebase().currentUser!.userId
                      );
                    },
                    onDone: () 
                    {
                      FirebaseCloudStorage.instance.reCacheNotes(
                        userId: AuthService.firebase().currentUser!.userId
                      );
                    },
                  );
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
                    Navigator.pushNamed(context, '/add_note/', arguments: note);
                  },
                );
              else
                return Text("Couldn't Fetch Your Notes");

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