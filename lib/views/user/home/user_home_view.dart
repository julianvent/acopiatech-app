import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/views/user/collection/user_collection_form.dart';
import 'package:acopiatech/widgets/user/user_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  late final userlastCollection = null;
  late final userCollectionOnGoing = [];

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthStateLoggedIn) {
      return const Center(child: Text('No autenticado'));
    }
    final user = authState.user;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 30,
              children: [
                // last collection
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 30,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Última solicitud de recolección',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Center(
                          child:
                              userlastCollection != null
                                  ? const CircularProgressIndicator()
                                  : Text(
                                    'No cuentas con recolecciones\n¡Solicita una ahora!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsPalette.backgroundDarkGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider(
                                      create:
                                          (_) => AddressBloc(
                                            user,
                                            AddressStorage(),
                                          )..add(
                                            const AddressEventLoadAdresses(),
                                          ),
                                      child: const UserCollectionForm(),
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            'Solicitar recolección',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ongoing collections max 3
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 30,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Recolecciones en camino',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Center(
                          child:
                              userCollectionOnGoing.isNotEmpty
                                  ? // Dios se apiade de nosotros 🤑🤑
                                  const CircularProgressIndicator()
                                  : Text(
                                    'Recuerda estar al pendiente el día de entrega\n¡Gracias por tu apoyo!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorsPalette.backgroundDarkGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                final controller =
                                    Get.find<UserNavigationController>();
                                controller.setView(1);
                              },
                              child: Text(
                                'Ver recoleciones',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorsPalette.backgroundDarkGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => BlocProvider(
                                          create:
                                              (_) => AddressBloc(
                                                user,
                                                AddressStorage(),
                                              )..add(
                                                const AddressEventLoadAdresses(),
                                              ),
                                          child: const UserCollectionForm(),
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                'Solicitar recoleción',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Encuentra un centro de acopio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 250,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 15,
                      children: [
                        // Map
                        Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '¡Añadir el mapa! ☠️☠️☠️',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
