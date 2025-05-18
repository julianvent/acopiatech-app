import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/views/user/address/address_list_view.dart';
import 'package:acopiatech/views/user/address/create_update_address_view.dart';
import 'package:acopiatech/widgets/custom_app_bar.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
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
    return Scaffold(
      appBar:
          CustomAppBar(
            title: 'Centros de acopio',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: BlocProvider.of<AddressBloc>(context),
                        child: CreateUpdateAddressView(
                          title: "Agregar centro de acopio",
                        ),
                      ),
                ),
              );
            },
          ).addAppBar,
      body: Column(
        children: [
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              if (state is AddressStateLoadedAddress) {
                return StreamBuilder(
                  stream: state.addressesStream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allAddresses =
                              snapshot.data as Iterable<Address>;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => BlocProvider.value(
                                          value: BlocProvider.of<AddressBloc>(
                                            context,
                                          ),
                                          child: CreateUpdateAddressView(
                                            address: address,
                                            title:
                                                "Actualizar centro de acopio",
                                          ),
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const CustomProgressIndicator(
                            loadingText: 'Cargando centros de acopio...',
                            spacing: 20,
                          );
                        }
                      default:
                        return const CustomProgressIndicator(
                          loadingText: 'Cargando centros de acopio...',
                          spacing: 20,
                        );
                    }
                  },
                );
              } else {
                return const CustomProgressIndicator(
                  loadingText: 'Cargando centros de acopio...',
                  spacing: 20,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
