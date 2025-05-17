import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/widgets/custom_card_text.dart';
import 'package:flutter/material.dart';

class AddressTile extends StatelessWidget {
  final Address address;
  const AddressTile({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        ],
      ),
    );
  }
}
