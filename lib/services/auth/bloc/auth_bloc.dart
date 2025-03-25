import 'package:acopiatech/services/auth/auth_provider.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateUninitialized(isLoading: true));

  // manage events and states
}
