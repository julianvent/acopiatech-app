import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/views/user/collection/user_collection_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCollectionView extends StatefulWidget {
  const UserCollectionView({super.key});

  @override
  State<UserCollectionView> createState() => _UserCollectionViewState();
}

class _UserCollectionViewState extends State<UserCollectionView> {
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthStateLoggedIn) {
      return const Center(child: Text('No autenticado'));
    }
    final user = authState.user;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Recolección como usuario', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Icon(Icons.recycling, size: 100, color: ColorsPalette.lightGreen),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider(
                          create:
                              (_) =>
                                  AddressBloc(AddressStorage())
                                    ..add(const AddressEventLoadAdresses()),
                          child: const UserCollectionForm(),
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsPalette.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                fixedSize: Size(200, 50),
              ),
              child: Text(
                'Solicitar recolección',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
