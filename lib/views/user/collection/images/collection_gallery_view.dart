import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/images/collection_images_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/images/collection_images_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/images/collection_images_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionGalleryView extends StatelessWidget {
  final Collection collection;

  const CollectionGalleryView({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    context.read<CollectionImagesBloc>().add(
      CollectionImagesEventLoadImages(
        ownerUserId: collection.ownerUserId,
        collectionId: collection.documentId,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Evidencias",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorsPalette.neutralGray,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CollectionImagesBloc, CollectionImagesState>(
        builder: (context, state) {
          if (state is CollectionImagesStateLoadedImages) {
            if (state.isLoading) {
              return CustomProgressIndicator(
                loadingText: 'Cargando evidencias...',
                spacing: 20,
              );
            }
            return SafeArea(
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                        itemCount: state.imageUrls!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Mostrar la imagen en pantalla completa
                                  return Dialog(
                                    child: Image.network(
                                      state.imageUrls![index],
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.network(
                              state.imageUrls![index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return CustomProgressIndicator(
            loadingText: 'Cargando evidencias...',
            spacing: 20,
          );
        },
      ),
    );
  }
}
