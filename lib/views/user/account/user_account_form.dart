import 'dart:io';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserAccountForm extends StatefulWidget {
  const UserAccountForm({super.key, required this.user});
  final AuthUser user;
  @override
  State<UserAccountForm> createState() => _UserAccountFormState();
}

class _UserAccountFormState extends State<UserAccountForm> {
  File? userProfileImage;
  final _picker = ImagePicker();
  late final AuthUser user = widget.user;

  Future<void> pickUserProfileImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userProfileImage = File(image.path);
        // Now send the image to the server or save it locally
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  late final String? _name = user.name ?? '';
  late final String? _lastName;
  late final String _phoneNumber;

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
                            userProfileImage != null
                                ? Image.file(userProfileImage!)
                                : Center(
                                  child: Image.asset(
                                    ImagesRoutes.mascota,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: FloatingActionButton(
                          onPressed: () {
                            pickUserProfileImage();
                          },
                          mini: true,
                          child: const Icon(Icons.account_circle),
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
                  UserTextField(
                    fieldName: 'Número de teléfono',
                    filled: false,
                    myIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
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
