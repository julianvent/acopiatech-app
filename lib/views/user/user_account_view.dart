import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Vista de cuenta de usuario'),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventLogOut());
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
