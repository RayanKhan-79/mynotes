import 'package:flutter/cupertino.dart';
import 'package:mynotes/service/cloud/cloud_note.dart';

@immutable
class CloudState 
{
  final Exception? exception;
  final bool isLoading;
  final String loadingText;
  const CloudState({required this.exception, required this.isLoading, this.loadingText = "Loading......."});
}

class UnitilizedState extends CloudState
{
  const UnitilizedState({required super.exception, required super.isLoading});
}

class NoteEditorState extends CloudState
{
  final CloudNote note;
  const NoteEditorState({required this.note, required super.exception, required super.isLoading});
}

class NotesListViewState extends CloudState
{
  final bool isSearching;
  const NotesListViewState({required this.isSearching, required super.exception, required super.isLoading});
}