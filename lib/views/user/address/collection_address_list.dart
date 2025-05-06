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
  late List<Address> addressList;
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    addressList = widget.addresses.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 20,
        children: [
          if (addressList.isEmpty)
            const Center(
              child: Text(
                'No tienes direcciones guardadas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          for (var address in addressList)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: RadioListTile<Address>(
                  selectedTileColor: ColorsPalette.backgroundDarkGreen,
                  value: address,
                  groupValue: _selectedAddress,
                  onChanged: (Address? selectedAddress) {
                    setState(() {
                      _selectedAddress = selectedAddress;
                    });
                    if (selectedAddress != null) {
                      widget.onTap(selectedAddress);
                    }
                  },
                  title: Text('${address.street}, ${address.neighborhood}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(address.phoneNumber),
                      Text('${address.city}, ${address.state}'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
