
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState 
{
  final Exception? exception;
  final bool isLoading;
  final String loadingText;
  const AuthState({required this.exception, this.loadingText = 'Loading', required this.isLoading});
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
}

class ResetPasswordState extends AuthState
{
  final bool emailSent;
  const ResetPasswordState({required super.exception, required super.isLoading, required this.emailSent});
}