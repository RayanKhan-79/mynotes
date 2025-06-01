import 'package:mynotes/service/auth/auth_exceptions.dart';
import 'package:mynotes/service/auth/auth_provider.dart';
import 'package:mynotes/service/auth/auth_user.dart';
import 'package:test/test.dart';

void main()
{
  group('Mock Auth', ()
  {
    final provider = MockAuthProvider();

    test('Not Initialized by Default', ()
    {
      expect(provider.initialized, false);
    });

    test('Cannot Logout if user is not logged in', ()
    {
      expect(provider.logout(), throwsA(TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to initialize in < 2 seconds', 
      timeout: Timeout(Duration(seconds: 2)), 
      () async
      {
        await provider.initialize();
        expect(provider.initialized, true);  
      }
    );

    test('User should be null after initialization', ()
    {
      expect(provider.getUser(), null);
    });

    test('Create user should delegate to the login function', () async
    {
      final badEmail = provider.signup(email: 'reject@gmail.com', password: 'any');
      expect(badEmail, throwsA(TypeMatcher<LoginException>()));

      final badPassword = provider.signup(email: 'someone@gmail.com', password: 'reject');
      expect(badPassword, throwsA(TypeMatcher<LoginException>()));

      final user = await provider.signup(email: 'email', password: 'password');
      expect(user, provider.getUser());
      expect(user.isEmailVerified(), false);
    });

    test('Logged in user should be able to get verified', () async
    {
      await provider.sendEmailVerification();
      expect(provider.getUser(), isNotNull);
      expect(provider.getUser()!.isEmailVerified(), true);
    });

    test('Allow Loggin in after logging out', () async
    {
      await provider.logout();
      await provider.login(email: 'email', password: 'password');

      expect(provider.getUser(), isNotNull);
    });

    



  });
}

class NotInitializedException {}
class AlreadyInitializedException {}

class MockAuthProvider implements AuthProvider
{
  bool initialized = false;
  AuthUser? user;

  @override
  Future<void> deleteUser() 
  {
    throw UnimplementedError();
  }

  @override
  AuthUser? getUser() 
  {
    if (!initialized)
      throw NotInitializedException();

    return user;
  }

  @override
  Future<void> initialize() async
  {
    if (initialized) throw AlreadyInitializedException();
    await Future.delayed(Duration(seconds: 1));
    initialized = true;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async
  {
    if (initialized == false) throw NotInitializedException();
    if (email == 'reject@gmail.com') throw LoginException();
    if (password == 'reject') throw LoginException();

    await Future.delayed(Duration(seconds: 1));
    user = AuthUser(email: email, verified: false);
    return user!;
  }

  @override
  Future<void> logout() async 
  {
    if (initialized == false) throw NotInitializedException();
    if (user == null) throw UnknownException();
    user = null;
  }

  @override
  Future<void> sendEmailVerification() async 
  {
    if (initialized == false) throw NotInitializedException();
    if (user == null) throw UnknownException();
    user = AuthUser(email: user!.email, verified: true);
  }

  @override
  Future<AuthUser> signup({required String email, required String password}) async
  {
    return login(email: email, password: password);
  }
  
}