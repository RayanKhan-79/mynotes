
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class DatabaseView extends StatelessWidget 
{
  final _controller = TextEditingController();
  
  DatabaseView({super.key});


  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar
      (
        title: Text('Execute SQL queries', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Column
      (
        children: [
          TextField(
            maxLines: null,
            controller: _controller,
          ),
          TextButton(
            onPressed: () async 
            {
              // var result = await NotesService.instance.db!.rawQuery(_controller.text);
              // dev.log('--------------');
              // for (var line in result)
              //   dev.log(line.toString());
            },
            child: Text('Run')
          ),
          TextButton(
            onPressed: ()
            {
              Navigator.pop(context);
            }, 
            child: Text('Return')
          )
        ],
      )
    );
  }
}