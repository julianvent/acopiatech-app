import 'package:acopiatech/services/auth/auth_provider.dart';
import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  // auth services
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser?> get currentUser => provider.currentUser;

  @override
  Future<void> initalize() async {
    await provider.initalize();
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  }) => provider.createUser(name: name, email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

  @override
  Future<String> updateName({required String name}) =>
      provider.updateName(name: name);
}
