import 'package:flutter/material.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/views/dropoff_list_view.dart';

class UserDropoffListView extends StatelessWidget {
  const UserDropoffListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Centros de Acopio')),
      body: StreamBuilder(
        stream: AddressStorage().allDropOffs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final dropOffs = snapshot.data as Iterable<Address>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropoffListView(
                  dropoffs: dropOffs,
                  length: dropOffs.length,
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
