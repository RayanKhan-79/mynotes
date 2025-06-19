import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_events.dart';
import 'package:mynotes/service/cloud/firebase_cloud_service.dart';
import 'package:mynotes/utilities/dialogs.dart';
import 'package:mynotes/views/notes_list_view.dart';

import '../service/auth/bloc/auth_event.dart' show LogoutEvent;

class NotesView extends StatelessWidget {
  const NotesView({super.key});

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