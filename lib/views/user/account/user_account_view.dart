import 'dart:io';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/views/user/account/user_account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  File? userProfileImage;
  final _picker = ImagePicker();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          final user = state.user;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
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
                          // Positioned(
                          //   bottom: 1,
                          //   right: 1,
                          //   child: FloatingActionButton(
                          //     onPressed: () {
                          //       pickUserProfileImage();
                          //     },
                          //     mini: true,
                          //     child: const Icon(Icons.account_circle),
                          //   ),
                          // ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          user.name ?? user.email,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  UserAccountCard(
                    title: 'Editar perfil',
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAccountForm(user:user,),
                        ),
                      );
                    },),
                  UserAccountCard(
                    title: 'Métodos de pago',
                    icon: Icons.credit_card_off,
                    onTap: () {},
                  ),
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
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class UserAccountCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const UserAccountCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsPalette.backgroundDarkGreen,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTap,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            onPressed: onTap,
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
