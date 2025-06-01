import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/crud/databse_note.dart';
import 'package:mynotes/service/crud/notes_service.dart';
import 'package:mynotes/utilities/methods.dart';
import 'dart:developer' as dev show log;

class AddNoteView extends StatefulWidget 
{
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> 
{

  DatabaseNote? _activeNote;
  late final TextEditingController _textController;

  @override
  void initState()
  {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() async
    {      
      await NotesService.instance.updateNote(noteId: _activeNote!.id, text: _textController.text);
      _activeNote = await NotesService.instance.fetchNoteById(noteId: _activeNote!.id);
      test();
    });
  }

  @override
  void dispose() 
  {
    _textController.dispose();
    _autoDeleteNote();
    super.dispose();
  }

  void test() async
  {
    var note = await NotesService.instance.fetchNoteById(noteId: 5);
    dev.log(note.toString());
  }

  void _autoDeleteNote() async
  {
    if (_activeNote != null && _activeNote!.text.isEmpty)
    {
      await NotesService.instance.deleteNote(noteId: _activeNote!.id);
    }
  }

  Future<void> createNote() async
  {
    _activeNote = getBuildContextArgument<DatabaseNote>(context);

    if (_activeNote != null) 
    {
      _textController.text = _activeNote!.text;
      return;
    }

    try
    {
      await NotesService.instance.open();
      var owner = await NotesService.instance.fetchUserByEmail(email: AuthService.firebase().getUser()!.email);
      _activeNote  = await NotesService.instance.createNote(owner: owner);    
    }
    catch (e)
    {
      dev.log(e.toString());
      showErrorDialog(context, e.toString());
      rethrow;
    }

  }

  @override
  Widget build(BuildContext context) 
  {
    return FutureBuilder
    (
      future: createNote(),
      builder: (context, snapshot) 
      {
        switch (snapshot.connectionState)
        {
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar
              (
                title: const Text("Notes View", style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.blue,
              ),
              body: TextField(
                maxLines: null, 
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Start Typing here'
                ),
              )
            );
          default:
            return Center(child: CircularProgressIndicator());
        }
      } 
    );
  }
}