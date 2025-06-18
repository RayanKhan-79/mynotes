
import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:mynotes/service/cloud/bloc/cloud_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_events.dart';

class SearchDialog 
{

  final StreamController<String> searchWords;
  late void Function() _dismisserFunction;
  void Function()? onDissmiss;

  SearchDialog._singletonConstructor() : searchWords = StreamController<String>.broadcast();
  static final SearchDialog _instance = SearchDialog._singletonConstructor();


  static SearchDialog get instance => _instance;

  void dissmissDialog()
  {
    _dismisserFunction();
  }

  void showDialog(BuildContext context, CloudBloc bloc)
  {
    if (onDissmiss == null)
      throw Exception();

    final controller = TextEditingController();
    late OverlayEntry entry;

    _dismisserFunction = () async
    {
      entry.remove();
      controller.dispose();
      dev.log(searchWords.isClosed.toString());
    };

    entry = OverlayEntry
    (
      builder: (context) 
      {
        return Positioned
        (
          right: 10,
          bottom: 30,
          child: Container
          (
            constraints: BoxConstraints
            (
              minHeight: 100,
              maxWidth: 200,
            ),
            child: Material
            (
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightBlue,
              child: Padding
              (
                padding: const EdgeInsets.all(8.0),
                child: Column
                (
                  children:
                  [
                    TextField
                    (
                      controller: controller,
                      autofocus: true,
                      autocorrect: false,
                      decoration: InputDecoration(hintText: 'Enter text here', contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                    ),
                    Row
                    (
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: 
                      [
                        TextButton
                        (
                          onPressed: () 
                          {
                            dev.log(controller.text);
                            searchWords.add(controller.text);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.amber
                          ),
                          child: Text('Search')
                        ),
                        TextButton
                        (
                          onPressed: () => bloc.add(ClearSearchEvent()),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.amber
                          ),
                          child: Text('Cancel')
                        )
                      ],
                    )
                  ]
                ),
              ),
            )
          )
        );
      }
    );

    Overlay.of(context).insert(entry);
  }
}