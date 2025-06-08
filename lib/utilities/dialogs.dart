import 'package:flutter/material.dart';

Future<T?> showGenericDialogBox<T>({required BuildContext context,required String title,required String content,required Map<String,T?> valueMap})
{
  return showDialog
  (
    context: context,
    builder: (context) => AlertDialog
    (
      scrollable: true,
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

void Function() showLoadingDialog(BuildContext context)
{
  final dialog = AlertDialog
  (
    title: Text("Loading Please Wait"),
    content: CircularProgressIndicator(),
  );

  showDialog
  (
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog
  );

  return () => Navigator.pop(context);
}