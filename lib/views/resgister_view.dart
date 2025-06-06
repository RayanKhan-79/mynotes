// ignore_for_file: unused_import

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth_exceptions.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/bloc/auth_bloc.dart';
import 'package:mynotes/service/bloc/auth_event.dart';
import 'package:mynotes/service/crud/notes_service.dart';
import 'package:mynotes/utilities/methods.dart';
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
    return Scaffold
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
              try
              {
                final event = RegisterEvent(email: emailController.text, password: passwordController.text);
                context.read<AuthBloc>().add(event);
              } 
              on WeakPasswordException
              {
                showErrorDialog(context, 'Your password must be at least 6 characters long');
              }
              on EmailAlreadyInUseException
              {
                showErrorDialog(context, 'Email already in use');
              }
              on UnknownException
              {
                showErrorDialog(context, 'Unknown Exception');
              }

            }, 
            child: Text("Register")
          ),
          TextButton
          (
            onPressed: ()
            {
              Navigator.of(context).pushNamedAndRemoveUntil
              (
                '/login/',
                (route) => false,
              );
            }, 
            child: const Text('Already Registered? Login Here')
          )
        ],
      )
    );
  }
}