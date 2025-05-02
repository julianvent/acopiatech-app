import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/views/user/address/address_list_view.dart';
import 'package:acopiatech/views/user/address/create_update_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropOffPointView extends StatefulWidget {
  const DropOffPointView({super.key});

  @override
  State<DropOffPointView> createState() => _DropOffPointViewState();
}

class _DropOffPointViewState extends State<DropOffPointView> {
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
        if (state is AddressStateCreatingUpdatingAddress) {
          return CreateUpdateAddressView();
        } else if (state is AddressStateLoadedAddress) {
          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text(
                  'Centros de Acopio',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            body: StreamBuilder(
              stream: state.addressesStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allAddresses = snapshot.data as Iterable<Address>;
                      if (allAddresses.isEmpty) {
                        return Column(
                          children: [
                            const Center(
                              child: Text(
                                'No hay centros de acopio registrados',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AddressBloc>().add(
                                  AddressEventShouldCreateUpdateAddress(
                                    address: null,
                                  ),
                                );
                              },
                              child: const Text('Agregar centro de acopio'),
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: AddressListView(
                                  addresses: allAddresses,
                                  onDeleteAddress: (address) {
                                    context.read<AddressBloc>().add(
                                      AddressEventDeleteAddress(
                                        documentId: address.documentId,
                                      ),
                                    );
                                  },
                                  onTap: (address) {
                                    context.read<AddressBloc>().add(
                                      AddressEventShouldCreateUpdateAddress(
                                        address: address,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AddressBloc>().add(
                                    AddressEventShouldCreateUpdateAddress(
                                      address: null,
                                    ),
                                  );
                                },
                                child: const Text('Agregar centro de acopio'),
                              ),
                            ],
                          ),
                        );
                      }
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
