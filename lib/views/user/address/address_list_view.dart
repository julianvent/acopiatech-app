import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/utilities/dialogs/delete_dialog.dart';
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
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
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
                        '${address.street} #${address.extNumber}, ${address.neighborhood}',
                      ),
                    ),
                    subtitle: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(address.phoneNumber),
                        Text('${address.city}, ${address.state}'),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteAddress(address);
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    // return Container(
    //   padding: const EdgeInsets.all(20),
    //   decoration: BoxDecoration(
    //     color: Colors.amber[50],
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: Stack(
    //     children: [
    //       Positioned(
    //         top: 0,
    //         right: 0,
    //         child: Icon(
    //           Icons.location_on_outlined,
    //           color: ColorsPalette.neutralGray,
    //           size: 40,
    //         ),
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             '${address!.street} ${address!.neighborhood}, ${address!.zipCode}',
    //             style: const TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.w600,
    //               color: Colors.black,
    //             ),
    //             textAlign: TextAlign.justify,
    //           ),
    //           const SizedBox(height: 8),
    //           Text(
    //             '${address!.city}, ${address!.state}',
    //             style: const TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.w600,
    //               color: Colors.black,
    //             ),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
