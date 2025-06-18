// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/helpers/loading/loading_dialog.dart';
import 'package:mynotes/service/auth/auth_exceptions.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/auth/auth_user.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_event.dart';
import 'package:mynotes/service/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;


class LoginView extends StatefulWidget
{
    final String title;
    const LoginView({super.key, this.title = "Login"});

    @override
    State<LoginView> createState() =>_LoginViewState();
}

class _LoginViewState extends State<LoginView>
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
        return BlocListener<AuthBloc, AuthState>
        (
          listener: (context, state) async
          {
            if (state is LoggedOutState)
            {
              if (state.exception != null) 
              {
                if (state.exception is WrongCredentialsAuthException)
                  await showErrorDialog(context, 'Could not find a user with the entered credentials, please confirm that your email and password are correct or that you are a registered user.');
                if (state.exception is InvalidEmailAuthException)
                  await showErrorDialog(context, 'Invalid Email');
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
                        context.read<AuthBloc>().add(LoginEvent
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
                      child: const Text("Login")
                    ),
                    TextButton
                    (
                      onPressed: ()
                      {
                        context.read<AuthBloc>().add(ShouldRegisterEvent());
                      }, 
                      style: TextButton.styleFrom
                      (
                        fixedSize: Size(150, 60),
                        backgroundColor: Colors.amber
                      ),
                      child: const Text('Register Here')
                    ),
                    TextButton
                    (
                      onPressed: ()
                      {
                        context.read<AuthBloc>().add(SendResetPasswordEmailEvent(email: null));
                      }, 
                      style: TextButton.styleFrom
                      (
                        fixedSize: Size(150, 60),
                        backgroundColor: Colors.amber
                      ),
                      child: const Text('Forgot Password')
                    )
                  ],
                ),
              )
          )
        );
    }
}

// rayankhannexus@gmail.com
// qwerty123