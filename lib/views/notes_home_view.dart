import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/helpers/loading/loading_dialog.dart';
import 'package:mynotes/helpers/searching/search_dialog.dart';
import 'package:mynotes/service/cloud/bloc/cloud_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_events.dart';
import 'package:mynotes/service/cloud/bloc/cloud_state.dart';
import 'package:mynotes/views/note_editor_view.dart';
import 'package:mynotes/views/notes_view.dart';

class NotesHomeView extends StatefulWidget
{
  const NotesHomeView({super.key});

  @override
  State<NotesHomeView> createState() => _NotesHomeViewState();
}

class _NotesHomeViewState extends State<NotesHomeView>
{
  @override
  void initState()
  {
    super.initState();
    context.read<CloudBloc>().add(InitializeEvent());
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<CloudBloc, CloudState>(
      listener: (context, state)
      {
        if (state.isLoading)
          LoadingDialog.instance.show(context, state.loadingText);
        else
          LoadingDialog.instance.hide();

        if (state is NotesListViewState)
          if (state.isSearching)
            SearchDialog.instance.showDialog(context, context.read<CloudBloc>());
      },
      builder: (context, state) {
        if (state is NotesListViewState)
          return NotesView();
        if (state is NoteEditorState)
          return NoteEditorView(state.note);

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    );
  }
}