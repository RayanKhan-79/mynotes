// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/auth/firebase_auth_provider.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/cloud/bloc/cloud_bloc.dart';
import 'package:mynotes/service/crud/notes_service.dart';
import 'package:mynotes/views/note_editor_view.dart';
import 'package:mynotes/views/notes_home_view.dart';
import 'package:mynotes/views/verification_view.dart';
import 'views/resgister_view.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  runApp(const App());
}

class App extends StatelessWidget 
{
    const App({super.key});

    @override
    Widget build(BuildContext context) 
    {
        return MaterialApp
        (
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData
            (
                primarySwatch: Colors.blue
            ),
            home: MultiBlocProvider
            (
              providers: 
              [
                BlocProvider(
                  create: (context) => AuthBloc(provider: AuthService.firebase())
                ),
                BlocProvider(
                  create: (context) => CloudBloc()
                ),
              ],
              child: HomeView(),
            ),
        );
    }
}