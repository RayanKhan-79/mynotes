import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_event.dart';
import 'package:mynotes/service/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs.dart';

class ResetPasswordView extends StatefulWidget {

  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late TextEditingController _textController;

  @override
  void initState() 
  {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() 
  {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async
      {
        if (state is ResetPasswordState)
          if (state.emailSent == true)
            await showInfoDialog(context, 'Please open your inbox to reset your password');
      },
      child: Scaffold
      (
        appBar: AppBar
        (
          title: Text("Password Reset", style: TextStyle(color: Colors.white)),
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
                controller: _textController,
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(hintText: "Enter Your Email Here"),
              ),
              TextButton
              (
                onPressed: () 
                {
                  context.read<AuthBloc>().add(SendResetPasswordEmailEvent(email: _textController.text));
                },
                style: TextButton.styleFrom(
                  fixedSize: Size(150, 60),
                  backgroundColor: Colors.amber
                ),
                child: Text('Send Password Reset Email', textAlign: TextAlign.center)
              ),
              TextButton
              (
                onPressed: () 
                {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                style: TextButton.styleFrom(
                  fixedSize: Size(150, 60),
                  backgroundColor: Colors.amber
                ),
                child: Text('Back To Login')
              )
            ], 
          ),
        ),
      ),
    );
  }
}