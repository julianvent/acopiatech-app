import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/views/user/create_address_view.dart';
import 'package:acopiatech/widgets/user_address_preview.dart';
import 'package:acopiatech/widgets/user_menu_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAddressView extends StatefulWidget {
  const UserAddressView({super.key});

  @override
  State<UserAddressView> createState() => _UserDirectionViewState();
}

class _UserDirectionViewState extends State<UserAddressView> {
  static final List<Map<String, dynamic>> _addresses = [];

  void _addAddress() async {
    final address = await Navigator.pushNamed(context, '/create-address');
    if (address != null) {
      setState(() {
        _addresses.add(address as Map<String, dynamic>);
      });
    }
  }

  static Map getDefaultAddress() {
    if (_addresses.isEmpty) {
      return {
        'street': 'Calle de la Amargura',
        'extNumber': '123',
        'neighborhood': 'Centro',
        'zipCode': '12345',
        'city': 'Ciudad de México',
        'state': 'CDMX',
      };
    } else {
      return _addresses[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AddressStateCreatingAddress) {
          return CreateAddressView();
        } else {
          return Scaffold(
            appBar: UserMenuAppBar(),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: _addresses.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final address = _addresses[index];
                        return UserAddressPreview(
                          street: address['street'],
                          extNumber: address['extNumber'],
                          neighborhood: address['neighborhood'],
                          zipCode: address['zipCode'],
                          city: address['city'],
                          state: address['state'],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<AddressBloc>().add(
                          AddressEventShouldCreateAddress(),
                        ),
                    child: const Text('Agregar dirección'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
