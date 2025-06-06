
import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/utilities/methods.dart';

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
        children: 
        [
          Text("We've Sen't You A Verification Email, Please Open It To Verify Your Account"),
          TextButton
          (
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            }, 
            child: Text('Resend It')
          ),
          TextButton(
            onPressed: () async {
              if (AuthService.firebase().getUser()!.verified)
              {
                await showInfoDialog(context, "Thank You, We Are Now Redirecting You To The Login Page");
                Navigator.pushNamedAndRemoveUntil(context, '/login/', (route) => false);
              }
              else
              {
                await showErrorDialog(context, "Sorry But Your Account Couldn't Be Verified");
              }
            }, 
            child: Text("I've Clicked It")
          )
        ],
      )
    );
  }
}