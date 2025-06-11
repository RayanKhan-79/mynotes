// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/helpers/loading/loading_dialog.dart';
import 'package:mynotes/service/auth/auth_exceptions.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/auth/auth_user.dart';
import 'package:mynotes/service/bloc/auth_bloc.dart';
import 'package:mynotes/service/bloc/auth_event.dart';
import 'package:mynotes/service/bloc/auth_state.dart';
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
    // void Function()? _shutDownLoadingScreen;


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
                if (state.exception is LoginException)
                  await showErrorDialog(context, 'Invalid-Credentials');
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
              body: Column
              (
                children: 
                [
                  TextField
                  (
                    controller: emailController,
                    autocorrect: false, 
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
                    child: const Text("Login")
                  ),
                  TextButton
                  (
                    onPressed: ()
                    {
                      context.read<AuthBloc>().add(ShouldRegisterEvent());
                    }, 
                    child: const Text('Register Here')
                  )
                ],
              )
          )
        );
    }
}

// rayankhannexus@gmail.com
// qwerty123