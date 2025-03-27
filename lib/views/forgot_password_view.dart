import 'dart:developer';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/auth_exceptions.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordView();
}

class _ForgotPasswordView extends State<ForgotPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateForgotPassword) {
          if (state.exception is InvalidEmailAuthException) {
            log('Invalid email');
          } else if (state.exception is UserNotFoundAuthException) {
            log('User not found');
          } else if (state.exception is GenericAuthException) {
            log('Auth error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Image(
              image: AssetImage(ImagesRoutes.fondoContrasenia),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Recuperación de contraseña 🔑",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          "Ingresa un correo electrónico para recuperar tu contraseña",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: ColorsPalette.darkCian,
                                ),
                                hintText: 'acopiatito@example.com',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.email),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: ColorsPalette.darkCian,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: ColorsPalette.darkCian,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            FilledButton(
                              onPressed: () {
                                final toEmail = _emailController.text;
                                context.read<AuthBloc>().add(
                                  AuthEventForgotPassword(email: toEmail),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: ColorsPalette.darkCian,
                              ),
                              child: Text(
                                'Recuperar contraseña',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(AuthEventLogOut());
                              },
                              child: const Text('Volver a inicio de sesión'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
