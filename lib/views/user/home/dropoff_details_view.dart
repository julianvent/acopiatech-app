import 'package:flutter/material.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/widgets/map_widget.dart';

class DropoffDetailsView extends StatelessWidget {
  final Address dropoff;

  const DropoffDetailsView({super.key, required this.dropoff});

  @override
  Widget build(BuildContext context) {
    final fullAddress =
        '${dropoff.street} ${dropoff.extNumber}, ${dropoff.neighborhood}, ${dropoff.city}, ${dropoff.state}';

    return Scaffold(
      appBar: AppBar(title: const Text('Centro de Acopio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 40,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: MapCollection(address: fullAddress),
            ),
            Text(
              'Dirección',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(fullAddress, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
