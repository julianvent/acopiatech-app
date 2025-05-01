import 'package:flutter/material.dart';

class CollectionGalleryView extends StatelessWidget {
  final List<String> images; // URLs de las imágenes

  const CollectionGalleryView({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Imágenes')),
      body: SafeArea(
        child: Column(
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
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Mostrar la imagen en pantalla completa
                            return Dialog(
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                      child: Image.network(images[index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
