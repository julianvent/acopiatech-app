import 'dart:io';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:acopiatech/views/user/account/user_account_form.dart';
import 'package:acopiatech/views/user/account/user_bonus_view.dart';
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
                spacing: 10,
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
                                        ImagesRoutes.logotipoA,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Mis puntos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Obtener puntos del usuario
                              Row(
                                children: [
                                  Text(
                                    'Cambiar por puntos',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider<CollectionBloc>(
                                              create:
                                                  (context) => CollectionBloc(
                                                    CollectionStorage(),
                                                  ),
                                              child: const UserBonusView(),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.wifi_protected_setup_outlined,
                                      size: 40,
                                      color: ColorsPalette.backgroundDarkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                          builder:
                              (_) => BlocProvider.value(
                                value: BlocProvider.of<AuthBloc>(context),
                                child: UserAccountForm(user: user),
                              ),
                        ),
                      );
                    },
                  ),
                  UserAccountCard(
                    title: 'Métodos de pago',
                    icon: Icons.credit_card,
                    onTap: () {},
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthEventLogOut());
                    },
                    child: const Text('Cerrar sesión', style: TextStyle(color: Colors.black)),
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
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
