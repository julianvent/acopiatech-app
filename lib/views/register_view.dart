import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/auth_exceptions.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/utilities/dialogs/error_dialog.dart';
import 'package:acopiatech/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        listener: (context, state) {
          if (state is AuthStateRegistering) {
            if (state.exception is WeakPasswordAuthException) {
              showErrorDialog(
                context,
                'La contraseña debe tener un mínimo de 6 carácteres y al menos un número.',
              );
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              showErrorDialog(
                context,
                'El correo electrónico ingresado ya está en uso.',
              );
            } else if (state.exception is GenericAuthException) {
              showErrorDialog(
                context,
                'Error al registrarse. Intente de nuevo.',
              );
            } else if (state.exception is InvalidEmailAuthException) {
              showErrorDialog(
                context,
                'El correo electrónico ingresado es inválido.',
              );
            } else if (state.exception is PasswordsDontMatchAuthException) {
              showErrorDialog(
                context,
                'Las contraseñas ingresadas no coinciden.',
              );
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
                          Text(
                            "Crea tu cuenta",
                            style: TextStyle(color: Colors.black, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
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
                              children: [
                                TextField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre',
                                    hintText: "Kevin Smith",
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Correo electrónico',
                                    hintText: "acopiatito@example.com",
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    prefixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextField(
                                  scrollPadding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Confirmar contraseña',
                                    prefixIcon: Icon(Icons.lock_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          FilledButton.icon(
                            onPressed: () {
                              final name = _nameController.text; // Check
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              final confirmPassword =
                                  _confirmPasswordController.text;

                              context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  name, // Check
                                  email,
                                  password,
                                  confirmPassword,
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: ColorsPalette.darkCian,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(color: Colors.white54),
                              ),
                              minimumSize: Size(double.infinity, 60),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            icon: Icon(Icons.person_add, color: Colors.white),
                            label: Text(
                              "Registrarse",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthEventLogOut());
                            },
                            child: Text(
                              '¿Ya tienes una cuenta? Inicia sesión ahora',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
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
