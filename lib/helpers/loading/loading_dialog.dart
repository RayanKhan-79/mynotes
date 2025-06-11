
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/helpers/loading/loading_controller.dart';

class LoadingDialog
{
  LoadingController? _controller;

  LoadingDialog._singletonConstructor();
  static final LoadingDialog _instance = LoadingDialog._singletonConstructor();
  static LoadingDialog get instance => _instance; 

  void show(BuildContext context, String text)
  {
    // if controller is null, evaluates to true
    // if controller is not null, update text and return skip condition
    if (!(_controller?.update(text) ?? false))
      _controller = _create(context, text);
  }

  void hide() 
  {
    _controller?.shutDown();
    _controller = null;
  }

  LoadingController _create(BuildContext context, String initial)
  {
    final size = MediaQuery.of(context).size;
    final streamController = StreamController<String>();
    streamController.add(initial);

    final OverlayEntry entry = OverlayEntry(
      builder: (context) {
        return Material
        (
          color: Colors.black54,
          child: Center(
            child: Container(
              constraints: BoxConstraints
              (
                minHeight: size.height * 0.1,
                maxHeight: size.height * 0.5,
                minWidth: size.width * 0.3,
                maxWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration
              (
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    StreamBuilder
                    (
                      stream: streamController.stream,
                      builder: (context, snapshot) 
                      {
                        if (snapshot.hasData)
                          return Text(snapshot.data as String);
                        else
                          return Text("null");
                      },
                    )
                  ],
                ),
              ),
              ),
            ),
        );
      },
    );

    Overlay.of(context).insert(entry);

    return LoadingController
    (
      shutDown: () 
      {
        streamController.close();
        entry.remove();
        return true;
      },
      update: (text) 
      {
        streamController.add(text);
        return true;
      },
    );
  }
}