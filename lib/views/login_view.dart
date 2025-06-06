// ignore_for_file: unused_import

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth_exceptions.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/auth/auth_user.dart';
import 'package:mynotes/service/bloc/auth_bloc.dart';
import 'package:mynotes/service/bloc/auth_event.dart';
import 'package:mynotes/utilities/methods.dart';
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
                      final event = LoginEvent(email: emailController.text, password: passwordController.text);
                      context.read<AuthBloc>().add(event);
                    } 
                    on LoginException
                    {
                      showErrorDialog(context, 'Couldn\'t login Please Ensure Your Credentials Are Correct');
                    }
                    on UnknownException
                    {
                      showErrorDialog(context, 'Unknown Exception');
                    }
                    catch (e)
                    {
                      showErrorDialog(context, e.toString());
                    }
                  }, 
                  child: const Text("Login")
                ),
                TextButton
                (
                  onPressed: ()
                  {
                    Navigator.of(context).pushNamedAndRemoveUntil
                    (
                      '/register/', 
                      (route) => false,
                    );
                  }, 
                  child: const Text('Register Here')
                )
              ],
            )
        );
    }
}

// rayankhannexus@gmail.com
// qwerty123