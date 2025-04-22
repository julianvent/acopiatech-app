import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/views/user/address/address_list_view.dart';
import 'package:flutter/material.dart';

class CollectionUpdate extends StatefulWidget {
  final Iterable<Address> addresses;
  final AddressCallback onTap;

  const CollectionUpdate({
    super.key,
    required this.addresses,
    required this.onTap,
  });

  @override
  State<CollectionUpdate> createState() => _CollectionUpdateState();
}

class _CollectionUpdateState extends State<CollectionUpdate> {
  Address? _selectedAddress;
  late List<Address> addressList;

  @override
  void initState() {
    super.initState();
    addressList = widget.addresses.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: RadioListTile<Address>(
            selectedTileColor: Colors.lightGreen,
            value: _selectedAddress = addressList[0],
            groupValue: _selectedAddress,
            onChanged: (Address? selectedAddress) {
              setState(() {
                _selectedAddress = selectedAddress;
              });
              if (selectedAddress != null) {
                widget.onTap(selectedAddress);
              }
            },
          ),
        ),
      ),
    );
  }
}
