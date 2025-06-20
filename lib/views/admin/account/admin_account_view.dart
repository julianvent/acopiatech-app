import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_event.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/views/admin/account/admin_account_form.dart';
import 'package:acopiatech/views/user/account/user_account_form.dart';
import 'package:acopiatech/widgets/custom_button.dart';
import 'package:acopiatech/widgets/custom_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAccountView extends StatefulWidget {
  const AdminAccountView({super.key});

  @override
  State<AdminAccountView> createState() => _AdminAccountViewState();
}

class _AdminAccountViewState extends State<AdminAccountView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedInAsAdmin) {
          final user = state.user;
          return Scaffold(
            body: Column(
              spacing: 2,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                              child: Center(
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: CustomDetail(
                    children: [
                      AdminAccountCard(
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
                      Center(
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

class AdminAccountCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const AdminAccountCard({
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          onPressed: onTap,
          icon: Icon(Icons.edit, color: Colors.white),
        ),
      ),
    );
  }
}
