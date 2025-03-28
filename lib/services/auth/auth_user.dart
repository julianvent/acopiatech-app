import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? name;
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? role;

  const AuthUser({
    required this.name,
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.role,
  });

  factory AuthUser.fromFirebase(firebase_auth.User user, {String? role}) =>
      AuthUser(
        name: user.displayName,
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        role: role,
      );
}
