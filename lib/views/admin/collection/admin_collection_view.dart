import 'package:acopiatech/widgets/admin/collection_preview.dart';
import 'package:flutter/material.dart';

class AdminCollectionView extends StatefulWidget {
  const AdminCollectionView({super.key});

  @override
  State<AdminCollectionView> createState() => _AdminCollectionViewState();
}

class _AdminCollectionViewState extends State<AdminCollectionView> {
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
