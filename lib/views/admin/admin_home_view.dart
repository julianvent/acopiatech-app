import 'package:flutter/material.dart';

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
          Container(color: Colors.amber,),
          Container(color: Colors.blueAccent),
          Container(color: Colors.redAccent),
          Container(color: Colors.greenAccent),
        ]
        ),
    );
  }
}