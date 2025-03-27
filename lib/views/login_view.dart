import 'dart:developer';

import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/auth_exceptions.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/views/forgot_password_view.dart';
import 'package:acopiatech/views/user/user_home_view.dart';
import 'package:acopiatech/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidCredentialAuthException) {
            log('Invalid credentials');
          } else if (state is GenericAuthException) {
            log('Auth error');
          }
        }
      },
      child: CustomScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Bienvenido a Acopiatech",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    "Hola de nuevo 👋🏻",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20).add(
                      EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200]!,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Correo electrónico',
                                  hintText: "acopiatito@example.com",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              context.read<AuthBloc>().add(
                                AuthEventForgotPassword(),
                              );
                            },
                            child: Text(
                              "¿Olvidaste tu contraseña?",
                              style: TextStyle(
                                color: ColorsPalette.hardGreen,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsPalette.backgroundDarkGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: Size(double.infinity, 60),
                            elevation: 5,
                          ),
                          onPressed: () {
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            context.read<AuthBloc>().add(
                              AuthEventLogIn(email, password),
                            );
                          },
                          child: Text(
                            "Iniciar sesión",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              AuthEventShouldRegister(),
                            );
                          },
                          child: Text('Crea tu cuenta ahora!!!! :DDDD'),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "O continuar con redes sociales",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(10),
                                shadowColor: Colors.grey[200]!,
                                elevation: 5,
                              ),
                              onPressed: () {
                                // Login with Google
                              },
                              child: Image(
                                image: AssetImage(ImagesRoutes.googleIcon),
                                width: 30,
                                height: 30,
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsPalette.facebookBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(10),
                                shadowColor: Colors.grey.withOpacity(0.2),
                                elevation: 5,
                              ),
                              onPressed: () {
                                // Login with Facebook
                              },
                              child: Image(
                                image: AssetImage(ImagesRoutes.fIcon),
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
