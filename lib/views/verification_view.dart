
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/bloc/auth_bloc.dart';
import 'package:mynotes/service/bloc/auth_event.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("We've Sen't You A Verification Email, Please Open It To Verify Your Account"),

          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(SendEmailVerificationEvent());
            }, 
            child: Text('Resend It')
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