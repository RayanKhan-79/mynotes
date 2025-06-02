import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

@immutable
class AuthUser
{
  final String userId;
  final String email;
  final bool verified;

  const AuthUser({required this.userId, required this.email, required this.verified});
  bool isEmailVerified() => verified;
  factory AuthUser.fromFirebase(User? user) => AuthUser(userId: user!.uid, email: user.email!, verified: user.emailVerified);
}