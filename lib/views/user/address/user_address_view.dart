import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/views/user/address/create_update_address_view.dart';
import 'package:acopiatech/views/user/address/address_list_view.dart';
import 'package:acopiatech/widgets/add_app_bar.dart';
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
    context.read<AddressBloc>().add(AddressEventLoadAdresses());
    return Scaffold(
      appBar:
          AddAppBar(
            title: 'Mis direcciones',
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: BlocProvider.of<AddressBloc>(context),
                          child: CreateUpdateAddressView(),
                        ),
                  ),
                ),
          ).addAppBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  if (state is AddressStateLoadedAddress) {
                    return StreamBuilder(
                      stream: state.addressesStream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final allAddresses =
                                  snapshot.data as Iterable<Address>;
                              return Column(
                                children: [
                                  AddressListView(
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
                                                value: BlocProvider.of<
                                                  AddressBloc
                                                >(context),
                                                child: CreateUpdateAddressView(
                                                  address: address,
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          default:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
