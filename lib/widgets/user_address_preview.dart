import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class UserAddressPreview extends StatelessWidget {
  final String street;
  final String extNumber;
  final String? intNumber;
  final String neighborhood;
  final String zipCode;
  final String? reference;
  final String city;
  final String state;

  const UserAddressPreview({
    super.key,
    required this.street,
    required this.extNumber,
    this.intNumber,
    required this.neighborhood,
    required this.zipCode,
    this.reference,
    required this.city,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.location_on_outlined,
              color: ColorsPalette.neutralGray,
              size: 40,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$street $neighborhood, $zipCode',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              Text(
                '$city, $state',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
