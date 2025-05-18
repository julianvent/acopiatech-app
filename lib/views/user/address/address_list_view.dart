import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/utilities/dialogs/delete_dialog.dart';
import 'package:acopiatech/widgets/custom_card_text.dart';
import 'package:flutter/material.dart';

typedef AddressCallback = void Function(Address address);

class AddressListView extends StatelessWidget {
  final Iterable<Address> addresses;
  final AddressCallback onDeleteAddress;
  final AddressCallback onTap;

  const AddressListView({
    super.key,
    required this.addresses,
    required this.onDeleteAddress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return const Center(child: Text('No existen direcciones registradas.'));
    }
    return Column(
      children: List.generate(addresses.length, (index) {
        final address = addresses.elementAt(index);
        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              onTap: () => onTap(address),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: CustomCardText(
                  '${address.street} ${address.extNumber}, ${address.neighborhood}',
                ),
              ),
              subtitle: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [Icon(Icons.phone), CustomCardText(address.phoneNumber)],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.location_on),
                      CustomCardText('${address.city}, ${address.state}'),
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
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsPalette.backgroundDarkGreen,
                        ),
                        onPressed: () async {
                          final shouldDelete = await showDeleteDialog(context);
                          if (shouldDelete) {
                            onDeleteAddress(address);
                          }
                        },
                        child: Text(
                          'Eliminar',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
