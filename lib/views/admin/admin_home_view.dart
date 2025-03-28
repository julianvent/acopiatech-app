import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon:Icon(Iconsax.home),
            label: 'Home',
          ),
          // NavigationDestination(
          //   icon: ,
          //   label: label)
          Container(color: Colors.redAccent),
          Container(color: Colors.greenAccent),
        ]
        ),
    );
  }
}