import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/views/user/home/dropoff_details_view.dart';
import 'package:acopiatech/widgets/custom_card_text.dart';
import 'package:flutter/material.dart';

class DropoffListView extends StatelessWidget {
  final Iterable<Address> dropoffs;
  final int length;

  const DropoffListView({
    super.key,
    required this.dropoffs,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    if (dropoffs.isEmpty) {
      return const Center(
        child: Text('No se han registrado centros de acopio.'),
      );
    }

    return Column(
      spacing: 20,
      children: List.generate(
        length > dropoffs.length ? dropoffs.length : length,
        (index) {
          final dropoff = dropoffs.elementAt(index);
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DropoffDetailsView(dropoff: dropoff),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: CustomCardText(
                          '${dropoff.street} ${dropoff.extNumber}, ${dropoff.neighborhood}',
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
                              CustomCardText(dropoff.phoneNumber),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.location_on),
                              CustomCardText(
                                '${dropoff.city}, ${dropoff.state}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
