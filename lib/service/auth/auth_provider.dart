import 'package:mynotes/service/auth/auth_user.dart';

abstract class AuthProvider
{
  AuthProvider();
  AuthUser? get currentUser;
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> verifyAndLogin({required String email, required String password});
  Future<AuthUser> signup({required String email, required String password});
  Future<void> sendResetPasswordEmail({required String email});
  Future<void> sendEmailVerification();
  Future<void> initialize();
  Future<void> logout();
  Future<void> deleteUser(); 
}