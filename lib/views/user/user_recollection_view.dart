import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/views/user/user_recollection_form.dart';
import 'package:flutter/material.dart';

class UserRecollectionView extends StatefulWidget {
  const UserRecollectionView({super.key});

  @override
  State<UserRecollectionView> createState() => _UserRecollectionViewState();
}

class _UserRecollectionViewState extends State<UserRecollectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recolección')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Recolección como usuario', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Icon(Icons.recycling, size: 100, color: ColorsPalette.lightGreen),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserRecollectionForm(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsPalette.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                fixedSize: Size(200, 50),
              ),
              child: Text(
                'Solicitar recolección',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
