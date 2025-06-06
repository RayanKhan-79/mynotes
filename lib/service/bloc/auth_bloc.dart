
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_provider.dart';
import 'package:mynotes/service/bloc/auth_event.dart';
import 'package:mynotes/service/bloc/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState>
{
  final AuthProvider provider;
  
  AuthBloc({required this.provider}) : super(LoadingState())
  {

    on<InitializeEvent>((event, emit) async 
    {
      try
      {
        await provider.initialize();
        if (provider.getUser() == null) {
          emit(LoggedOutState());
        }
        else if (provider.getUser()!.verified == false) {
          emit(UnVerifiedState());
        }
        else {
          emit(LoggedInState());
        }
      } 
      on Exception catch (e) 
      {
        emit(ExceptionState(e));  
      }

    });

    on<RegisterEvent>((event, emit) async
    {
      try 
      {
        await provider.signup(email: event.email, password: event.password);
        emit(UnVerifiedState());
      }
      on Exception catch (e) 
      {
        emit(ExceptionState(e));  
      }

    });

    on<LogoutEvent>((event, emit) async 
    {
      try 
      {
        await provider.logout();
        emit(LoggedOutState());
      } 
      on Exception catch (e) 
      {
        emit(ExceptionState(e));  
      }
      
    });

    on<LoginEvent>((event, emit) async 
    {
      try 
      {
        final user = await provider.login(email: event.email, password: event.password);
        if (user.verified)
          emit(LoggedInState());
        else
          emit(UnVerifiedState());
      } 
      on Exception catch (e) 
      {
        emit(ExceptionState(e));  
      }

    });
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);

    dev.log(change.toString());
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    dev.log(transition.toString());
  }
}