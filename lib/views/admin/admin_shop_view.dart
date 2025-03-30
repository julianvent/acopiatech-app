import 'package:flutter/material.dart';

class AdminShopView extends StatefulWidget {
  const AdminShopView({super.key});

  @override
  State<AdminShopView> createState() => _AdminShopViewState();
}

class _AdminShopViewState extends State<AdminShopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [Text('Vista de tienda de administrador')],
        ),
      ),
    );
  }
}
