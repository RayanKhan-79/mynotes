import 'package:flutter/material.dart';
import 'package:mynotes/service/cloud/cloud_note.dart';
import 'package:mynotes/utilities/methods.dart';

class NotesListView extends StatelessWidget 
{  
  final Iterable<CloudNote> notes;
  final void Function(CloudNote note) deleteCallback;
  final void Function(CloudNote note) openNoteCallback;

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
            notes.elementAt(index).text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton
          (
            onPressed: () async
            {
              if (await showDeleteDialog(context, 'Are You Sure You Want To Delete This Note?'))
                this.deleteCallback(notes.elementAt(index));
            },
            icon: Icon(Icons.delete)
          ),
          onTap: () 
          {
            this.openNoteCallback(notes.elementAt(index));
          },        
        );
      }
    );
  }
}