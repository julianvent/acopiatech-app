import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/views/user/collection/user_collection_form.dart';
import 'package:flutter/material.dart';

class UserCollectionView extends StatefulWidget {
  const UserCollectionView({super.key});

  @override
  State<UserCollectionView> createState() => _UserCollectionViewState();
}

class _UserCollectionViewState extends State<UserCollectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  MaterialPageRoute(builder: (context) => UserCollectionForm()),
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
