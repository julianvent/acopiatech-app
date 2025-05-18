import 'dart:io';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:acopiatech/views/user/account/user_account_form.dart';
import 'package:acopiatech/views/user/account/user_bonus_view.dart';
import 'package:acopiatech/widgets/custom_button.dart';
import 'package:acopiatech/widgets/custom_detail.dart';
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
            body: Column(
              spacing: 2,
              children: [
                CustomDetail(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 16,
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
                  ],
                ),
                CustomDetail(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            BlocBuilder<CollectionBloc, CollectionState>(
                              builder: (context, state) {
                                if (state is CollectionStateLoadedCollections) {
                                  return StreamBuilder(
                                    stream: state.collectionsStream,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          if (snapshot.hasData) {
                                            final collections =
                                                snapshot.data
                                                    as Iterable<Collection>;
                                            int totalPoints = collections.fold(
                                              0,
                                              (sum, collection) {
                                                return sum +
                                                    (collection.pointsEarned ??
                                                        0);
                                              },
                                            );
                                            return Text(
                                              '$totalPoints',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            );
                                          }
                                          break;
                                        default:
                                          return const Text('0');
                                      }
                                      return const Text('0');
                                    },
                                  );
                                }
                                return const Text('0');
                              },
                            ),
                            const Text(
                              'puntos',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        // Obtener puntos del usuario
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return BlocProvider<CollectionBloc>(
                                    create:
                                        (context) =>
                                            CollectionBloc(CollectionStorage()),
                                    child: UserBonusView(
                                      currentUser: state.user,
                                    ),
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
                Expanded(
                  child: CustomDetail(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthEventLogOut());
                          },
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          title: 'Cerrar sesión',
                          backgroundColor: ColorsPalette.neutralGray,
                          icon: Icon(Icons.logout_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
