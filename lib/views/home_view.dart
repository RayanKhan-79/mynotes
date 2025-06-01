// ignore_for_file: unused_import
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/resgister_view.dart';
import 'dart:developer' as dev show log;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder
    (
      future: Future.delayed(Duration(seconds: 1), (){}),
      builder: (context, snapshot) 
      {
        final user = AuthService.firebase().getUser();
        dev.log(user?.toString() ?? '');
        switch (snapshot.connectionState)
        {
          case ConnectionState.done:
            if (user == null || user.isEmailVerified() == false)
            {
              return LoginView();
            }
            else
            {
              return NotesView();
            }

          default:
            return Scaffold(body: Center(child: CircularProgressIndicator(value: null,)));
        }
      }
    );
  }
}