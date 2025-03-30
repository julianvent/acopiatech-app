import 'package:flutter/material.dart';

class UserNotificationView extends StatefulWidget {
  const UserNotificationView({super.key});

  @override
  State<UserNotificationView> createState() => _UserNotificationViewState();
}

class _UserNotificationViewState extends State<UserNotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: const Center(child: Text('Notificaciones para el usuario')),
    );
  }
}
