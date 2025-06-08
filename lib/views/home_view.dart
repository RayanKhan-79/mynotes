// ignore_for_file: unused_import
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/service/bloc/auth_bloc.dart';
import 'package:mynotes/service/bloc/auth_event.dart';
import 'package:mynotes/service/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/resgister_view.dart';
import 'dart:developer' as dev show log;

import 'package:mynotes/views/verification_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) 
  {
    context.read<AuthBloc>().add(InitializeEvent());
    
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) 
      {
        if (state is LoggedInState)
          return NotesView();
        
        if (state is LoggedOutState)
          return LoginView();

        if (state is RegisteringState)
          return RegisterView();

        if (state is UnVerifiedState)
          return VerificationView();

        return CircularProgressIndicator();
      },
    );
  }
}