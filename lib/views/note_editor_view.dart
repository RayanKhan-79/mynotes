import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_events.dart';
import 'package:mynotes/service/cloud/bloc/cloud_state.dart';
import 'package:mynotes/service/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs.dart';


class NoteEditorView extends StatefulWidget 
{
  final CloudNote _activeNote;
  const NoteEditorView(this._activeNote, {super.key});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> 
{

  late final TextEditingController _textController;

  @override
  void initState()
  {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() async
    {    
      context
        .read<CloudBloc>()
        .add(UpdateNoteEvent
        (
          note: widget._activeNote,
          updatedText: _textController.text
        ));
    });
    _textController.text = widget._activeNote.text;
  }

  @override
  void dispose() 
  {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return BlocListener<CloudBloc, CloudState>
    (
      listener: (context, state) async 
      {
        if (state is NoteEditorState)
          if (state.exception != null)
            await showErrorDialog(context, state.exception.toString());
      },
      child: Scaffold
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
                context.read<CloudBloc>().add(ShareNoteEvent(note: widget._activeNote));
              },
              icon: Icon(Icons.share)
            ),
            IconButton
            (
              onPressed: () async
              {
                context.read<CloudBloc>().add(LeaveEditorEvent(note: widget._activeNote));
              },
              icon: Icon(Icons.arrow_back)
            )
          ],
        ),
        body: TextField
        (
          maxLines: null, 
          controller: _textController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            hintText: 'Start Typing here'
          ),
        )
      )
    );
  }
}