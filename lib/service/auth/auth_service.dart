
import 'package:mynotes/service/auth/auth_provider.dart';
import 'package:mynotes/service/auth/auth_user.dart';
import 'package:mynotes/service/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider
{
  final AuthProvider provider;
  const AuthService({required this.provider});
  factory AuthService.firebase() => AuthService(provider: FirebaseAuthProvider());

  @override
  AuthUser? getUser() 
  {
    return provider.getUser();
  }

  @override
  Future<AuthUser> login({required String email, required String password}) 
  {
    return provider.login(email: email, password: password);
  }

  @override
  Future<void> logout() 
  {
    return provider.logout();
  }

  @override
  Future<void> sendEmailVerification() 
  {
    return provider.sendEmailVerification();
  }

  @override
  Future<AuthUser> signup({required String email, required String password}) 
  {
    return provider.signup(email: email, password: password);
  }
  
  @override
  Future<void> initialize() 
  {
    return provider.initialize();
  }
  
  @override
  Future<void> deleteUser() async
  {
    return provider.deleteUser();
  }
  
}