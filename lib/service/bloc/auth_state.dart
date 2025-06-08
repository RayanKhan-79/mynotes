
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class UnInitializedState implements AuthState
{
  final bool isLoading;

  UnInitializedState({required this.isLoading});
}

// on the register view
class RegisteringState implements AuthState
{
  final Exception? exception;
  final bool isLoading;
  RegisteringState({required this.exception, required this.isLoading});
}

// on verification view
class UnVerifiedState implements AuthState 
{
  final Exception? exception;
  final bool isLoading;
  final String email;
  final String password;
  const UnVerifiedState({required this.exception, required this.isLoading, required this.email, required this.password});
}

// verified and logged in, on notes view
class LoggedInState implements AuthState 
{
  final Exception? exception;
  final bool isLoading;
  const LoggedInState({required this.exception, required this.isLoading});
}

// on login view
class LoggedOutState implements AuthState
{
  final Exception? exception;
  final bool isLoading;
  const LoggedOutState({required this.exception, required this.isLoading});
}