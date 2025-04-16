import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/views/user/address/collection_address_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionAddressView extends StatefulWidget {
  const CollectionAddressView({super.key});

  @override
  State<CollectionAddressView> createState() => _CollectionAddressViewState();
}

class _CollectionAddressViewState extends State<CollectionAddressView> {
  Address? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    context.read<AddressBloc>().add(const AddressEventLoadAdresses());
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: 'Cargando direcciones');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AddressStateLoadedAddress) {
          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text(
                  'Direcciones',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            body: StreamBuilder(
              stream: state.addressesStream,
              builder: (context, snaphost) {
                switch (snaphost.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snaphost.hasData) {
                      final allAddresses = snaphost.data as Iterable<Address>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: CollectionAddressList(
                                addresses: allAddresses,
                                onTap: (address) {
                                  setState(() {
                                    _selectedAddress = address;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_selectedAddress != null) {
                                  Navigator.pop(context, _selectedAddress);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Selecciona una dirección"),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Confirmar dirección'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
