import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/views/user/address/address_list_view.dart';
import 'package:acopiatech/views/user/address/create_update_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  spacing: 20,
                  children: [
                    const Text(
                      'No tienes direcciones guardadas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value: BlocProvider.of<AddressBloc>(context),
                                  child: CreateUpdateAddressView(),
                                ),
                          ),
                        );
                      },
                      icon: Row(
                        children: [
                          Icon(
                            Icons.add_location_alt_outlined,
                            size: 50,
                            color: ColorsPalette.darkCian,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
