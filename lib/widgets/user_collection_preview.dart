import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class UserCollectionPreview extends StatelessWidget {
  const UserCollectionPreview({super.key});

  String getAddress() {
    return 'Calle 123, Colonia Centro, 12345';
  }

  String getStatus() {
    return 'En espera';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsPalette.backgroundHardGreen,
      margin: EdgeInsets.all(10),
      child: Material(
        child: ListTile(
          title: Text('Recolección a domicilio'),
          subtitle: Text(
            'Entregar en:\n$getAddress()',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: Column(
            spacing: 8,
            children: [
              Row(
                children: [
                  Text(
                    getStatus(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.circle, color: Colors.amber),
                ],
              ),
              Icon(Icons.more_vert, color: ColorsPalette.neutralGray),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
