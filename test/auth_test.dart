import 'package:acopiatech/services/auth/auth_exceptions.dart';
import 'package:acopiatech/services/auth/auth_provider.dart';
import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to initialize', () async {
      await provider.initalize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () async {
      expect(await provider.currentUser, null);
    });

    test(
      'Should be able to initialize before 2 seconds',
      () async {
        await provider.initalize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        name: 'name',
        email: 'correo',
        password: 'password',
      );
      expect(badEmailUser, throwsA(TypeMatcher<InvalidEmailAuthException>()));

      final badPassword = provider.createUser(
        name: 'name',
        email: 'correo@gmail.com',
        password: 'password',
      );
      expect(badPassword, throwsA(TypeMatcher<WeakPasswordAuthException>()));

      final user = await provider.createUser(
        name: 'name',
        email: 'correo@gmail.com',
        password: 'password123',
      );
      expect(await provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Create normal user should assign user role', () async {
      final user = await provider.currentUser;
      expect(user!.role, 'user');
    });

    test('Create admin user should assign admin role', () async {
      final user = await provider.createUser(
        name: 'name',
        email: 'acopiatechdev@gmail.com',
        password: 'password123',
      );
      expect(user.role, 'admin');
    });

    test('Logged in user should be able to get verified', () async {
      provider.sendEmailVerification();
      final user = await provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out a log in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'correo@gmail.com', password: 'password123');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  Future<AuthUser?> get currentUser async {
    await Future.delayed(const Duration(seconds: 1));
    return _user;
  }

  @override
  Future<void> initalize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "correo") throw InvalidEmailAuthException();
    if (password == "password") throw WeakPasswordAuthException();

    dynamic user;
    if (email == 'acopiatechdev@gmail.com') {
      user = AuthUser(
        name: 'name',
        id: 'id',
        email: email,
        isEmailVerified: false,
        role: 'admin',
      );
    } else {
      user = AuthUser(
        name: 'nombre',
        id: 'id',
        email: 'correo@gmail.com',
        isEmailVerified: false,
        role: 'user',
      );
    }
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    var newUser = AuthUser(
      name: 'name',
      id: 'id',
      email: 'email',
      isEmailVerified: true,
      role: 'role',
    );
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {}

  @override
  Future<String> updateName({required String name}) async {
    return '';
  }
}
