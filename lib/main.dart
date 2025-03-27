import 'dart:developer';

import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/auth/firebase_auth_provider.dart';
import 'package:acopiatech/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'AcopiaTech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        // TODO
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          log('Loading...');
        } else {
          log('OK');
        }
      },
      builder: (context, state) {
        // where scaffold = actual view
        if (state is AuthStateLoggedIn) {
          return const Scaffold(body: Center(child: Text('Home view')));
        } else if (state is AuthStateNeedsVerification) {
          return const Scaffold(body: Center(child: Text('Verification view')));
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const Scaffold(body: Center(child: Text('Register view')));
        } else if (state is AuthStateForgotPassword) {
          return const Scaffold(
            body: Center(child: Text('Forgot password view')),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
