
import 'package:flutter/foundation.dart';
import 'package:mynotes/service/cloud/cloud_note.dart';

@immutable
abstract class CloudEvent 
{
  const CloudEvent();
}

class InitializeEvent extends CloudEvent
{
  const InitializeEvent();
}

class AddNoteEvent extends CloudEvent
{
  const AddNoteEvent();
}

class SearchNoteEvent extends CloudEvent
{
  const SearchNoteEvent();
}

class ClearSearchEvent extends CloudEvent 
{
  const ClearSearchEvent();
}

class OpenNoteEvent extends CloudEvent 
{
  final String noteId;
  const OpenNoteEvent({required this.noteId});
}

class ShareNoteEvent extends CloudEvent
{
  final CloudNote note;
  const ShareNoteEvent({required this.note});
}

class LeaveEditorEvent extends CloudEvent
{
  final CloudNote note;
  const LeaveEditorEvent({required this.note});
}

class UpdateNoteEvent extends CloudEvent
{
  final CloudNote note;
  final String updatedText;
  const UpdateNoteEvent({required this.note, required this.updatedText});
}