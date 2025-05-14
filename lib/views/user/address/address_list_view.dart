import 'dart:developer';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef AddressCallback = void Function(Address address);

class AddressListView extends StatelessWidget {
  final Iterable<Address> addresses;
  final AddressCallback onDeleteAddress;
  final AddressCallback onTap;
  final int? length;

  const AddressListView({
    super.key,
    required this.addresses,
    required this.onDeleteAddress,
    required this.onTap,
    this.length,
  });

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return const Center(child: Text('No existen direcciones registradas.'));
    }
    return Column(
<<<<<<< HEAD
      children: List.generate(length == null ? addresses.length : length!, (index) {
=======
      spacing: 20,
      children: List.generate(addresses.length, (index) {
>>>>>>> 09248b98052d13b9f1b6921ed23d95b3c6d13558
        final address = addresses.elementAt(index);
        log(address.toString());
        return Stack(
          children: [
            Positioned.fill(
              bottom: 1,
              left: 1,
              right: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      ColorsPalette.backgroundHardGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () => onTap(address),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      '${address.street} ${address.extNumber}, ${address.neighborhood}',
                    ),
                  ),
                  subtitle: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.phone),
                          Text(address.phoneNumber),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.location_on),
                          Text('${address.city}, ${address.state}'),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsPalette.greenShadow,
                            ),
                            onPressed: () => onTap(address),
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorsPalette.backgroundDarkGreen,
                            ),
                            onPressed: () async {
                              final shouldDelete = await showDeleteDialog(
                                context,
                              );
                              if (shouldDelete) {
                                onDeleteAddress(address);
                              }
                            },
                            child: Text(
                              'Eliminar',
                              style: TextStyle(
                                fontSize: 12,
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
            ),
          ],
        );
      }),
    );
  }
}
