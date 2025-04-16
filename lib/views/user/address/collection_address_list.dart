import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/views/user/address/address_list_view.dart';
import 'package:flutter/material.dart';

class CollectionAddressList extends StatefulWidget {
  final Iterable<Address> addresses;
  final AddressCallback onTap;
  const CollectionAddressList({
    super.key,
    required this.addresses,
    required this.onTap,
  });

  @override
  State<CollectionAddressList> createState() => _CollectionAddressListState();
}

class _CollectionAddressListState extends State<CollectionAddressList> {
  Address? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.addresses.length,
      itemBuilder: (context, index) {
        final address = widget.addresses.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RadioListTile(
                selectedTileColor: ColorsPalette.lightGreen,
                value: address,
                selected: _selectedAddress == address,
                groupValue: _selectedAddress,
                onChanged: (Address? value) {
                  setState(() {
                    _selectedAddress = value;
                  });
                  if (value != null) widget.onTap(value);
                },
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '${address.street} #${address.extNumber}, ${address.neighborhood}',
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.phoneNumber),
                    Text('${address.city}, ${address.state}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
