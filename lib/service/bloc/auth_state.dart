
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  final Exception? exception;
  const AuthState({required this.isLoading, this.loadingText = 'Loading', required this.exception});
}

class UnInitializedState extends AuthState
{
  const UnInitializedState({required super.exception, required super.isLoading});
}

// on the register view
class RegisteringState extends AuthState
{
  const RegisteringState({required super.exception, required super.isLoading});
}

// on verification view
class UnVerifiedState extends AuthState 
{
  final String email;
  final String password;
  const UnVerifiedState({required super.exception, required super.isLoading, required this.email, required this.password});
}

// verified and logged in, on notes view
class LoggedInState extends AuthState 
{
  const LoggedInState({required super.exception, required super.isLoading});
}

// on login view
class LoggedOutState extends AuthState
{

  const LoggedOutState({required super.exception, required super.isLoading});

  @override
  String toString() {
    return "LoggedOutState {${exception?.toString() ?? 'null'} ${isLoading.toString()}}";
  }
}