import 'package:flutter/material.dart';
import 'package:mynotes/service/crud/databse_note.dart';
import 'package:mynotes/utilities/methods.dart';

class NotesListView extends StatelessWidget 
{  
  final List<DatabaseNote> notes;
  final void Function(DatabaseNote note) deleteCallback;
  final void Function(DatabaseNote note) openNoteCallback;

  const NotesListView({super.key, required this.notes, required this.deleteCallback, required this.openNoteCallback});

  @override
  Widget build(BuildContext context) 
  {
    return ListView.builder
    (
      itemCount: notes.length,
      itemBuilder: (context, index)
      {
        return ListTile
        (
          title: Text
          (
            notes[index].text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton
          (
            onPressed: () async
            {
              if (await showDeleteDialog(context, 'Are You Sure You Want To Delete This Note?'))
                this.deleteCallback(notes[index]);
            },
            icon: Icon(Icons.delete)
          ),
          onTap: () 
          {
            this.openNoteCallback(notes[index]);
          },        
        );
      }
    );
  }
}