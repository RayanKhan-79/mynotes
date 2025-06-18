
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_event.dart';

class VerificationView extends StatelessWidget 
{
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Verification', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column
      (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24,24,24,0),
            child: Text("We've sent you a verification email, please open your inbox and complete the verification process", textAlign: TextAlign.center),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(SendEmailVerificationEvent());
            }, 
            child: Text('Resend It'),
          ),
          
          TextButton (
            onPressed: () async {
              context.read<AuthBloc>().add(VeriyEmailEvent());
            }, 
            child: Text("I've Clicked It")
          )
        ],
      )
    );
  }
}