import 'package:flutter/material.dart';

class UserShopView extends StatefulWidget {
  const UserShopView({super.key});

  @override
  State<UserShopView> createState() => _UserShopViewState();
}

class _UserShopViewState extends State<UserShopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [Text('Vista de tienda de usuario')],
        ),
      ),
    );
  }
}
