import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  // final bool isAdmin;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    // required this.isAdmin,
  });

  factory AuthUser.fromFirebase(firebase_auth.User user) => AuthUser(
    id: user.uid,
    email: user.email!,
    isEmailVerified: user.emailVerified,
    // isAdmin: isAdmin,
  );
}
