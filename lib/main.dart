import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/auth/firebase_auth_provider.dart';
import 'package:acopiatech/views/forgot_password_view.dart';
import 'package:acopiatech/views/login_view.dart';
import 'package:acopiatech/views/register_view.dart';
import 'package:acopiatech/views/user/user_home_view.dart';
import 'package:acopiatech/views/verification_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AcopiaTech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        textTheme: GoogleFonts.rubikTextTheme(),
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
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Por favor espere un momento...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        // where scaffold = actual view
        if (state is AuthStateLoggedInAsAdmin) {
          // return const AdminHomeView();
          return Scaffold(
            appBar: AppBar(title: Text('Admin - ${state.user.name!}')),
            body: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventLogOut());
              },
              child: Text('Cerrar sesión'),
            ),
          );
        } else if (state is AuthStateLoggedIn) {
          // return const UserHomeView();
          return Scaffold(
            appBar: AppBar(title: Text(state.user.name!)),
            body: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventLogOut());
              },
              child: Text('Iniciar sesión'),
            ),
          );
        } else if (state is AuthStateNeedsVerification) {
          return const VerificationView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
