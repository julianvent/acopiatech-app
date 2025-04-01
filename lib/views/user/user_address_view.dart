import 'package:acopiatech/widgets/user_direction_preview.dart';
import 'package:acopiatech/widgets/user_menu_app_bar.dart';
import 'package:flutter/material.dart';

class UserAddressView extends StatefulWidget {
  const UserAddressView({super.key});

  @override
  State<UserAddressView> createState() => _UserDirectionViewState();
}

class _UserDirectionViewState extends State<UserAddressView> {
  final List<Map<String, dynamic>> _addresses = [];

  void _addAddress() async {
    final address = await Navigator.pushNamed(context, '/create-address');
    if (address != null) {
      setState(() {
        _addresses.add(address as Map<String, dynamic>);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserMenuAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: _addresses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  return UserDirectionPreview(
                    street: address['street'],
                    extNumber: address['extNumber'],
                    neighborhood: address['neighborhood'],
                    zipCode: address['zipCode'],
                    city: address['city'],
                    state: address['state'],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addAddress,
              child: const Text('Agregar dirección'),
            ),
          ],
        ),
      ),
    );
  }
}
