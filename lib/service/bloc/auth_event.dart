import 'package:flutter/widgets.dart';

@immutable
abstract class AuthEvent 
{
  const AuthEvent();
}

class InitializeEvent implements AuthEvent {}

class LoginEvent implements AuthEvent
{
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
}

class RegisterEvent implements AuthEvent
{
  final String email;
  final String password;
  const RegisterEvent({required this.email, required this.password});
}

class SendEmailVerificationEvent implements AuthEvent
{
  const SendEmailVerificationEvent();
}

class VeriyEmailEvent implements AuthEvent
{
  const VeriyEmailEvent();
}

class LogoutEvent implements AuthEvent
{
  const LogoutEvent();
}

class ShouldRegisterEvent implements AuthEvent
{
  const ShouldRegisterEvent();
}

class SendResetPasswordEmailEvent implements AuthEvent
{
  final String? email;
  const SendResetPasswordEmailEvent({required this.email});
}