import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/cloud_address.dart';
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
        if (state is AddressStateCreatingAddress) {
          return CreateAddressView();
        } else if (state is AddressStateLoadedAddress) {
          return Scaffold(
            body: StreamBuilder(
              stream: state.addressesStream,
              builder: (context, snaphost) {
                switch (snaphost.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snaphost.hasData) {
                      final allAddresses =
                          snaphost.data as Iterable<CloudAddress>;
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemCount: allAddresses.length,
                                separatorBuilder:
                                    (_, _) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final address = allAddresses.elementAt(index);
                                  return UserAddressPreview(address: address);
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
