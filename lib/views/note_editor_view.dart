import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/cloud/cloud_note.dart';
import 'package:mynotes/service/cloud/firebase_cloud_service.dart';
import 'package:mynotes/utilities/methods.dart';
import 'dart:developer' as dev show log;

import 'package:share_plus/share_plus.dart';

class NoteEditorView extends StatefulWidget 
{
  const NoteEditorView({super.key});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> 
{

  CloudNote? _activeNote;
  late final TextEditingController _textController;

  @override
  void initState()
  {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() async
    {      
      await FirebaseCloudStorage.instance.updateNote(noteId: _activeNote!.id, text: _textController.text);
      _activeNote = await FirebaseCloudStorage.instance.readNote(noteId: _activeNote!.id);
    });
  }

  @override
  void dispose() 
  {
    _textController.dispose();
    _autoDeleteNote();
    super.dispose();
  }

  void _autoDeleteNote() async
  {
    if (_activeNote != null && _activeNote!.text.isEmpty)
    {
      await FirebaseCloudStorage.instance.deleteNote(noteId: _activeNote!.id);
    }
  }

  Future<void> createNote() async
  {
    _activeNote = getBuildContextArgument<CloudNote>(context);

    if (_activeNote != null) 
    {
      _textController.text = _activeNote!.text;
      return;
    }

    try
    {      
      _activeNote  = await FirebaseCloudStorage.instance.createNote(userId: AuthService.firebase().getUser()!.userId);    
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
                actions: 
                [
                  IconButton
                  (
                    onPressed: () async 
                    {
                      if (_activeNote != null)
                        if (_activeNote!.text.isNotEmpty)
                        {
                          var param = ShareParams(text: _activeNote!.text);
                          SharePlus.instance.share(param);
                          return;
                        }

                      await showErrorDialog(context, 'Cannot Share Empty Note');

                    },
                    icon: Icon(Icons.share)
                  )
                ],
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