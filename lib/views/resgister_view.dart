// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth_exceptions.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_event.dart';
import 'package:mynotes/service/auth/bloc/auth_state.dart';
import 'package:mynotes/service/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

import 'package:mynotes/views/verification_view.dart';


class RegisterView extends StatefulWidget
{
  final String title;
  const RegisterView({super.key, this.title = "Register"});
  
  @override
  State<RegisterView> createState() =>_RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
{
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() 
  {    
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose()
  {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async
      {
        if (state is RegisteringState)
        {
          if (state.exception != null)
          {
            if (state.exception is EmailAlreadyInUseException)
              await showErrorDialog(context, 'Email Already In Use');
            if (state.exception is WeakPasswordException)
              await showErrorDialog(context, 'Weak Password, Must Be At Least 8 Characters Long');
            if (state.exception is FirebaseAuthException)
              await showErrorDialog(context, 'Firebase: ${state.exception.toString()}');
          }
        }
      },
      child: Scaffold
        (
          appBar: AppBar
          (
            title: Text(widget.title, style: TextStyle(color: Colors.white)), 
            backgroundColor: Colors.blue,
          ),
          body: Padding
          (
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column
              (
                spacing: 10,
                children: 
                [
                  TextField
                  (
                    controller: emailController,
                    autocorrect: false, 
                    autofocus: true,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  TextField
                  (
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(hintText: "Password")
                  ),
                  TextButton
                  (
                    onPressed: () async
                    {
                      context.read<AuthBloc>().add(RegisterEvent
                      (
                        email: emailController.text,
                        password: passwordController.text
                      ));
                    },
                    style: TextButton.styleFrom
                    (
                      fixedSize: Size(150, 60),
                      backgroundColor: Colors.amber
                    ),
                    child: Text("Register")
                  ),
                  TextButton
                  (
                    onPressed: ()
                    {
                      context.read<AuthBloc>().add(LogoutEvent());
                    }, 
                    style: TextButton.styleFrom
                    (
                      fixedSize: Size(150, 60),
                      backgroundColor: Colors.amber
                    ),
                    child: const Text('Already Registered? Login Here', textAlign: TextAlign.center, textScaler: TextScaler.linear(0.9))
                  )
                ],
              ),
            ),
          )
        )
    );
  }
}