import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = 'Por favor espere un momento...',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({
    required this.exception,
    required super.isLoading,
  });
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required super.isLoading,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateLoggedInAsAdmin extends AuthState {
  final AuthUser user;
  const AuthStateLoggedInAsAdmin({
    required this.user,
    required super.isLoading,
  });
}

class AuthStateUpdatingName extends AuthState {
  final Exception? exception;
  const AuthStateUpdatingName({
    required super.isLoading,
    required this.exception,
  });
}
