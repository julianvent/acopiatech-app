import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class ImageListView extends StatefulWidget {
  final List<String> images; // Lista de rutas de las imágenes

  const ImageListView({super.key, required this.images});

  @override
  State<ImageListView> createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  late final List<String> imagesRoutes;
  var transformedImages = [];

  Future<dynamic> getSizeImage() async {
    transformedImages = [];

    for (int i = 0; i < imagesRoutes.length; i++) {
      final imageObject = {};

      await rootBundle.load(imagesRoutes[i]).then((value) {
        imageObject['path'] = imagesRoutes[i];
        imageObject['size'] = value.lengthInBytes;
      });
      transformedImages.add(imageObject);
    }
  }

  @override
  void initState() {
    imagesRoutes = widget.images;
    getSizeImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Imágenes')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                decoration: BoxDecoration(color: Colors.white),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return RawMaterialButton(
                      child: InkWell(
                        child: Ink.image(
                          // image: AssetImage(transformedImages\[index\]['path']),
                          image: AssetImage(
                            'lib/assets/images/LogoAcopiaTech.png',
                          ),
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Image.asset(
                                'lib/assets/images/LogoAcopiaTech.png', // Usar la misma ruta para la previsualización
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  itemCount: imagesRoutes.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
