import 'package:flutter/material.dart';

class AdminMenuView extends StatefulWidget {
  const AdminMenuView({super.key});

  @override
  State<AdminMenuView> createState() => _AdminMenuViewState();
}

class _AdminMenuViewState extends State<AdminMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [Text('Vista de menú de administrador')]),
      ),
    );
  }
}
