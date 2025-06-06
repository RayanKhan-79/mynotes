
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class LoadingState implements AuthState 
{
  const LoadingState();
}

class UnVerifiedState implements AuthState 
{
  const UnVerifiedState();
}

class ExceptionState implements AuthState 
{
  final Exception exception;
  const ExceptionState(this.exception);
}

class LoggedInState implements AuthState 
{
  const LoggedInState();
}

class LoggedOutState implements AuthState
{
  const LoggedOutState();
}