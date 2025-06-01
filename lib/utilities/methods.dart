import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

Future<void> verifyEmail(String email, String password, BuildContext context) async
{
  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  if (!context.mounted) return;

  showDialog 
  (
    context: context,
    builder:(context) 
    {
      return AlertDialog
      (
        title: Text('We\'ve Sent You a verification link via email, please open your email on click it'),
        actions: 
        [
          TextButton
          (
            onPressed: () async 
            {
              dev.log('Sign in process starting');
              await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
              dev.log(FirebaseAuth.instance.currentUser?.toString() ?? '');
              
              if (FirebaseAuth.instance.currentUser?.emailVerified ?? false)
                Navigator.of(context).pushNamedAndRemoveUntil('/notes_view/', (route)=>false);
            }, 
            child: const Text('I\'ve Clicked it')
          ),
          TextButton
          (
            onPressed: () async 
            {
              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            }, 
            child: const Text('Resend it')
          ),
          TextButton
          (
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
            child: const Text('I\'ll do it later')
          )
        ]
      );
    },
  );
}

Future<T?> showGenericDialogBox<T>({required BuildContext context,required String title,required String content,required Map<String,T?> valueMap})
{
  return showDialog
  (
    context: context,
    builder: (context) => AlertDialog
    (
      title: Text(title),
      content: Text(content),
      actions: valueMap.keys.map((key) 
      {
        final T? value = valueMap[key];
        return TextButton
        (
          onPressed: () 
          {
            if (value == null)
              Navigator.pop(context);
            else
              Navigator.pop(context, value);
          }, 
          child: Text(key)
        );
      }).toList()
    )
  );
}

Future<void> showInfoDialog(BuildContext context, String content)
{
  return showGenericDialogBox<void>
  (
    context: context,
    title: 'Info',
    content: content,
    valueMap: { 'Ok' : null }
  );
}

Future<void> showErrorDialog(BuildContext context, String content)
{
  return showGenericDialogBox<void>
  (
    context: context,
    title: 'An Error Occured',
    content: content,
    valueMap: { 'Ok' : null }
  );
}

Future<bool> showLogoutDialog(BuildContext context)
{
  return showGenericDialogBox<bool>
  (
    context: context,
    title: 'Logging Out',
    content: 'Are You Sure You Want to Log Out?',
    valueMap: { 
      'Yes' : true, 
      'No' : false 
    }
  ).then((value) => value ?? false);
}

Future<bool> showDeleteDialog(BuildContext context, String content)
{
  return showGenericDialogBox<bool>
  (
    context: context,
    title: 'Delete',
    content: content,
    valueMap: { 
      'Yes' : true, 
      'No' : false 
    }
  ).then((value) => value ?? false);
}

T? getBuildContextArgument<T>(BuildContext context)
{
  Object? arg = ModalRoute.of(context)?.settings.arguments; 
  
  if (arg != null && arg is T)
    return arg as T;

  return null;
}