

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';

class AdminAccountForm extends StatefulWidget {
  final AuthUser user;
  const AdminAccountForm({super.key, required this.user});

  @override
  State<AdminAccountForm> createState() => _AdminAccountFormState();
}

class _AdminAccountFormState extends State<AdminAccountForm> {
  late final AuthUser user = widget.user;

  final _formKey = GlobalKey<FormState>();
  // late final String? _name = user.name ?? '';
  // late final String? _lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar perfil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                spacing: 26.0,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child:
                            Center(
                                  child: Image.asset(
                                    ImagesRoutes.mascota,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                      ),
                      ],
                  ),
                  UserTextField(
                    myIcon: Icons.person,
                    fieldName: 'Nombres',
                    filled: false,
                  ),
                  UserTextField(
                    myIcon: Icons.person,
                    fieldName: 'Apellidos',
                    filled: false,
                  ),
                  UserTextField(
                    fieldName: 'Correo electrónico',
                    initialValue: user.email,
                    filled: false,
                    myIcon: Icons.email,
                    isEnabled: false,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsPalette.backgroundDarkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: Text(
                      'Confirmar cambios',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}