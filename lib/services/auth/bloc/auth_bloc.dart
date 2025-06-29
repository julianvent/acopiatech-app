import 'package:acopiatech/services/auth/auth_exceptions.dart';
import 'package:acopiatech/services/auth/auth_provider.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateUninitialized(isLoading: true)) {
    // manage events and states
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initalize();
      final user = await provider.currentUser;

      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
      );

      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else if (user.role == 'admin') {
        emit(AuthStateLoggedInAsAdmin(user: user, isLoading: false));
      } else if (user.role == 'user') {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Espera un momento mientras iniciamos tu sesión...',
        ),
      );

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);
        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          if (user.role == 'admin') {
            emit(AuthStateLoggedInAsAdmin(user: user, isLoading: false));
          } else {
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(isLoading: false, exception: e));
      }
    });

    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    // should register
    on<AuthEventShouldRegister>((event, emit) {
      emit(AuthStateRegistering(exception: null, isLoading: false));
    });

    // register
    on<AuthEventRegister>((event, emit) async {
      final name = event.name;
      final email = event.email;
      final password = event.password;
      final confirmPassword = event.confirmPassword;

      if (password != confirmPassword) {
        emit(
          AuthStateRegistering(
            exception: PasswordsDontMatchAuthException(),
            isLoading: false,
          ),
        );
      } else {
        try {
          emit(AuthStateRegistering(exception: null, isLoading: true));
          await provider.createUser(
            name: name,
            email: email,
            password: password,
          );

          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      }
    });

    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ),
      );

      final email = event.email;
      if (email == null) {
        return;
      }

      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ),
      );

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(
        AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ),
      );
    });

    // update name
    on<AuthEventUpdateName>((event, emit) async {
      emit(AuthStateUpdatingName(isLoading: true, exception: null));
      try {
        await provider.updateName(name: event.name);
        final user = await provider.currentUser;

        if (user!.role == 'admin') {
          emit(AuthStateLoggedInAsAdmin(user: user, isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateUpdatingName(isLoading: false, exception: e));
      }
    });
  }
}
