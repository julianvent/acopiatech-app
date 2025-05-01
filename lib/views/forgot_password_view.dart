import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/auth_exceptions.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/utilities/dialogs/error_dialog.dart';
import 'package:acopiatech/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:acopiatech/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          context.read<AuthBloc>().add(AuthEventLogOut());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Volviendo a la pantalla de inicio de sesión...'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateForgotPassword) {
            if (state.exception is InvalidEmailAuthException) {
              showErrorDialog(
                context,
                'El correo electrónico ingresado es inválido.',
              );
            } else if (state.exception is UserNotFoundAuthException) {
              showErrorDialog(context, 'El usuario no ha sido encontrado.');
            } else if (state.exception is GenericAuthException) {
              showErrorDialog(context, 'Error de autenticación.');
            }

            if (state.hasSentEmail) {
              _emailController.clear();
              await showPasswordResetSentDialog(context);
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
                    Image(
                      image: AssetImage(ImagesRoutes.logoAcopiatech),
                      width: 300,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
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
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Recuperación de contraseña",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Ingresa un correo electrónico para recuperar tu contraseña",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
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
                          SizedBox(height: 30),
                          FilledButton(
                            onPressed: () {
                              final toEmail = _emailController.text;
                              context.read<AuthBloc>().add(
                                AuthEventForgotPassword(email: toEmail),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: ColorsPalette.darkCian,
                              minimumSize: Size(100, 50),
                            ),
                            child: Text(
                              'Recuperar contraseña',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
