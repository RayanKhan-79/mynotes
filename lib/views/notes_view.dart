
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/crud/database_user.dart';
import 'package:mynotes/service/crud/notes_service.dart';
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
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) 
                      Navigator.pushNamedAndRemoveUntil(context, '/login/', (route)=>false);
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
      body: Center(child: FutureBuilder
      (
        future: fetchUserAndUpdateCache(AuthService.firebase().getUser()!.email),
        builder: (context, userSnapshot) 
        {
          switch (userSnapshot.connectionState) 
          {
            case ConnectionState.done:
              return StreamBuilder
              (
                stream: NotesService.instance.controller.stream,
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
                            await NotesService.instance.deleteNote(noteId: note.id);
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
              );
            default:
              return CircularProgressIndicator();
          }
        }
      ),),
    );
  }
}

Future<DatabaseUser> fetchUserAndUpdateCache(String email) async
{
  var user = await NotesService.instance.fetchUserByEmail(email: email);
  await NotesService.instance.updateCache(user: user);
  return user;
}