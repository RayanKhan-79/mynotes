
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/bloc/auth_bloc.dart';
import 'package:mynotes/service/bloc/auth_event.dart';
import 'package:mynotes/service/cloud/firebase_cloud_service.dart';
import 'package:mynotes/utilities/methods.dart';
import 'package:mynotes/views/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

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
                    // await FirebaseAuth.instance.signOut();
                    // if (context.mounted) 
                    //   Navigator.pushNamedAndRemoveUntil(context, '/login/', (route)=>false);
                  }
                  return;
                case 2:
                  Navigator.pushNamed(context, '/database/');
                  return;
              }
            },
            itemBuilder: (context) 
            {
              return 
              [
                PopupMenuItem(value: 1, child: Text('logout')),
                PopupMenuItem(value: 2, child: Text('execute'))
              ];
            },
          )
        ],
      ),
      body: Center(
        child: StreamBuilder
        (
          stream: FirebaseCloudStorage.instance.streamNotes(userId: AuthService.firebase().getUser()!.userId),
          builder: (context, snapshot) 
          {
            switch (snapshot.connectionState)
            {
              case ConnectionState.active:
              case ConnectionState.waiting:
                // return Text('Notes');
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
      ),
    );
  }
}