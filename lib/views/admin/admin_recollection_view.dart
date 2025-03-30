import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class AdminRecollectionView extends StatefulWidget {
  const AdminRecollectionView({super.key});

  @override
  State<AdminRecollectionView> createState() => _AdminRecollectionViewState();
}

class _AdminRecollectionViewState extends State<AdminRecollectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Vista de recolección de administrador'),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para cerrar sesión
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsPalette.hardGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Recolección'),
            ),
          ],
        ),
      ),
    );
  }
}
