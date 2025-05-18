import 'dart:io';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/utilities/dialogs/error_dialog.dart';
import 'package:acopiatech/utilities/generics/validate_field.dart';
import 'package:acopiatech/widgets/custom_app_bar.dart';
import 'package:acopiatech/widgets/custom_button.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  AuthUser? user;
  String? _name;
  String? _email;

  Future<void> pickUserProfileImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userProfileImage = File(image.path);
        // Now send the image to the server or save it locally
      });
    }
  }

  @override
  void initState() {
    user = widget.user;
    _name = user!.name ?? '';
    _email = user!.email;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: 'Actualizando perfil...',
          );
        } else {
          LoadingScreen().hide();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Actualizar datos').navigatorAppBar,
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
                          clipBehavior: Clip.hardEdge,
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            shape: BoxShape.circle,
                          ),
                          child:
                              userProfileImage != null
                                  ? Image.file(userProfileImage!)
                                  : Center(
                                    child: Image.asset(
                                      ImagesRoutes.logotipoA,
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
                            backgroundColor: ColorsPalette.darkCian,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                    UserTextField(
                      myIcon: Icons.person,
                      initialValue: _name,
                      onSaved: (name) => _name = name,
                      validator: (value) => validateField(value),
                      fieldName: 'Nombre completo',
                      filled: false,
                    ),
                    UserTextField(
                      fieldName: 'Correo electrónico',
                      initialValue: _email,
                      onSaved: (email) => _email = email,
                      filled: false,
                      myIcon: Icons.email,
                      isEnabled: false,
                    ),
                    Column(
                      spacing: 12,
                      children: [
                        CustomButton(
                          title: 'Confirmar cambios',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                _formKey.currentState!.save();

                                context.read<AuthBloc>().add(
                                  AuthEventUpdateName(name: _name!.trim()),
                                );
                              } on Exception {
                                LoadingScreen().hide();
                                showErrorDialog(
                                  context,
                                  'Error al actualizar sus datos, intente de nuevo.',
                                );
                              }
                            } else {
                              return;
                            }
                          },
                        ),
                        Text(
                          'Después de actualizar sus datos, es probable que estos tarden en reflejarse en la aplicación.',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
