import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

@immutable
class AuthUser
{
  final String email;
  final bool verified;

  const AuthUser({required this.email, required this.verified});
  bool isEmailVerified() => verified;
  factory AuthUser.fromFirebase(User? user) => AuthUser(email: user!.email??'', verified: user.emailVerified);
}