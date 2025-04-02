import 'package:acopiatech/widgets/collection_preview.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Text('Vista de recolección de administrador'),
            RecollectionPreview(clientDirection: "Dirección del cliente"),
            RecollectionPreview(clientDirection: "Dirección del cliente"),
            RecollectionPreview(clientDirection: "Dirección del cliente"),
          ],
        ),
      ),
    );
  }
}
