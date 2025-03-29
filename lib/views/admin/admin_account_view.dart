import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAccountView extends StatefulWidget {
  const AdminAccountView({super.key});

  @override
  State<AdminAccountView> createState() => _AdminAccountViewState();
}

class _AdminAccountViewState extends State<AdminAccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Vista de cuenta de administrador'),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventLogOut());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsPalette.darkGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
