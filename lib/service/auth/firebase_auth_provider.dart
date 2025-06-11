import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/service/auth/auth_exceptions.dart';
import 'package:mynotes/service/auth/auth_user.dart';
import 'package:mynotes/service/auth/auth_provider.dart';
import 'package:mynotes/firebase/firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider
{

  @override
  Future<void> initialize() async
  {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  AuthUser? currentUser;

  @override
  AuthUser? getUser()
  {
    currentUser = (FirebaseAuth.instance.currentUser != null) ? AuthUser.fromFirebase(FirebaseAuth.instance.currentUser) : null; 
    return currentUser;
  }

  @override
  Future<AuthUser> verifyAndLogin({required String email, required String password}) async
  {
    await login(email: email, password: password);
    
    if (FirebaseAuth.instance.currentUser!.emailVerified == false)
      throw UnVerifiedEmailException();
  
    return getUser()!;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async 
  {
    try 
    {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      currentUser = getUser();
            
      return currentUser!;

    } 
    on FirebaseAuthException
    {
      throw LoginException();
    }
    
  }

  @override
  Future<void> logout() async 
  {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> sendEmailVerification() async
  {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  @override
  Future<AuthUser> signup({required String email, required String password}) async
  {
    try
    {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      currentUser = getUser();

      return currentUser!;
    }
    on FirebaseAuthException catch(e)
    {
      if (e.code == 'weak-password')
        throw WeakPasswordException();

      if (e.code == 'email-already-in-use')
        throw EmailAlreadyInUseException();
    
      rethrow;
    }
  }
  
  @override
  Future<void> deleteUser() async
  {
    await FirebaseAuth.instance.currentUser?.delete();
    currentUser = null;
  }
}
