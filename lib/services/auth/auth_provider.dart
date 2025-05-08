import 'package:acopiatech/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initalize();
  Future<AuthUser?> get currentUser;

  Future<AuthUser> logIn({required String email, required String password});

  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required String toEmail});

  Future<String> updateName({required String name});
}
