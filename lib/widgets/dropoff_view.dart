import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/views/dropoff_list_view.dart';
import 'package:flutter/material.dart';

class DropOffView extends StatelessWidget {
  const DropOffView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AddressStorage().allDropOffs(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final dropOffs = snapshot.data as Iterable<Address>;
              return Column(
                children: [DropoffListView(dropoffs: dropOffs, length: 3)],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
