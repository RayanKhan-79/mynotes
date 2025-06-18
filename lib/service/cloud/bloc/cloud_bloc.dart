
import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/helpers/searching/search_dialog.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/cloud/bloc/cloud_events.dart';
import 'package:mynotes/service/cloud/bloc/cloud_state.dart';
import 'package:mynotes/service/cloud/cloud_note.dart';
import 'package:mynotes/service/cloud/firebase_cloud_service.dart';
import 'package:share_plus/share_plus.dart';

class CloudBloc extends Bloc<CloudEvent, CloudState>
{
  CloudBloc() : super(UnitilizedState(exception: null, isLoading: false))
  {
    on<InitializeEvent>((event, emit) async
    {
      try
      {
        FirebaseCloudStorage.instance.initializeListener(
          userId: AuthService.firebase().currentUser!.userId
        );
        
        FirebaseCloudStorage.instance.cacheNotes(
          userId: AuthService.firebase().currentUser!.userId
        );
        emit(NotesListViewState
        (
          isSearching: false,
          exception: null,
          isLoading: false
        ));
      }
      on Exception catch (e)
      {
        emit(UnitilizedState
        (
          exception: e,
          isLoading: false
        ));
      }
    });

    on<ClearSearchEvent>((event, emit) 
    {
      SearchDialog.instance.dissmissDialog();
      FirebaseCloudStorage.instance.cacheNotes(
          userId: AuthService.firebase().currentUser!.userId
      );
      emit(NotesListViewState
      (
        isSearching: false,
        exception: null,
        isLoading: false
      ));

    });

    on<SearchNoteEvent>((event, emit) 
    {
      try
      {
        SearchDialog.instance.searchWords.stream.listen(
          (data) => FirebaseCloudStorage.instance.searchNotes(
            string: data,
            userId: AuthService.firebase().currentUser!.userId
          ),
        );

        SearchDialog.instance.onDissmiss = () 
        {
          add(ClearSearchEvent());
          // SearchDialog.instance.dissmissDialog();
          // FirebaseCloudStorage.instance.cacheNotes(
          //     userId: AuthService.firebase().currentUser!.userId
          // );
          // emit(NotesListViewState
          // (
          //   isSearching: false,
          //   exception: null,
          //   isLoading: false
          // ));
        };

        emit(NotesListViewState
        (
          isSearching: true,
          exception: null,
          isLoading: false
        ));
      }
      on Exception catch (e)
      {
        emit(NotesListViewState
        (
          isSearching: false,
          exception: e,
          isLoading: false
        ));
      }
    });

    on<AddNoteEvent>((event, emit) async
    {
      try
      {
        emit(NotesListViewState
        (
          isSearching: false,
          exception: null, 
          isLoading: true
        ));        

        final note = await FirebaseCloudStorage.instance.createNote(
            userId: AuthService.firebase().currentUser!.userId
        );

        emit(NoteEditorState
        (
          note: note,
          exception: null, 
          isLoading: false
        ));
      }
      on Exception catch (e)
      {
        emit(NotesListViewState
        (
          isSearching: false,
          exception: e,
          isLoading: false
        ));
      }
    });

    on<OpenNoteEvent>((event, emit) async
    {
      try
      {
        emit(NotesListViewState
        (
          isSearching: false,
          exception: null,
          isLoading: true
        ));

        final note = await FirebaseCloudStorage.instance.readNote(noteId: event.noteId);

        emit(NoteEditorState
        (
          note: note,
          exception: null,
          isLoading: false
        ));
      }
      on Exception catch (e)
      {
        emit(NotesListViewState
        (
          isSearching: false,
          exception: e,
          isLoading: false
        ));
      }
    });

    on<LeaveEditorEvent>((event, emit) async
    {
      try
      {

        final note = (state as NoteEditorState).note;

        emit(NoteEditorState
        (
          note: note,
          exception: null,
          isLoading: true
        ));

        if (note.text.isEmpty)
          await FirebaseCloudStorage.instance.deleteNote(noteId: note.id);
      
        FirebaseCloudStorage.instance.initializeListener(userId: AuthService.firebase().currentUser!.userId);
        FirebaseCloudStorage.instance.cacheNotes(userId: AuthService.firebase().currentUser!.userId);

        emit(NotesListViewState
        (
          isSearching: false,
          exception: null,
          isLoading: false
        ));
      } 
      on Exception catch (e)
      {
        emit(NoteEditorState
        (
          note: (state as NoteEditorState).note,
          exception: e,
          isLoading: false
        ));
      }

    });

    on<UpdateNoteEvent>((event, emit) async
    {
      
      try
      {

        await FirebaseCloudStorage.instance.updateNote(noteId: event.note.id, text: event.updatedText);

        emit(NoteEditorState
        (
          note: CloudNote(id: event.note.id, text: event.updatedText, userId: event.note.userId),
          exception: null,
          isLoading: false
        ));
      }
      on Exception catch (e)
      {
        emit(NoteEditorState
        (
          note: event.note,
          exception: e,
          isLoading: false
        ));
      }

    });

    on<ShareNoteEvent>((event, emit) 
    {
      try
      {
        if (event.note.text.isEmpty)
          throw Exception("Cannot Share Empty Note");

        final params = ShareParams(text: event.note.text);
        SharePlus.instance.share(params);
        emit(state);
      }
      on Exception catch (e)
      {
        emit(NoteEditorState
        (
          note: (state as NoteEditorState).note,
          exception: e,
          isLoading: false
        ));
      }
    });

  }


  @override
  void onTransition(Transition<CloudEvent, CloudState> transition) 
  {
    super.onTransition(transition);
    dev.log('Cloud => ${transition.toString()}');
  }
}