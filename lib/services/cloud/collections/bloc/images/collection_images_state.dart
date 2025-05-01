import 'package:flutter/material.dart' show immutable;

@immutable
abstract class CollectionImagesState {
  final bool isLoading;
  final String? loadingText;

  const CollectionImagesState({
    required this.isLoading,
    this.loadingText = 'Cargando imágenes..',
  });
}

class CollectionImagesStateUnintialized extends CollectionImagesState {
  const CollectionImagesStateUnintialized({required super.isLoading});
}

class CollectionImagesStateLoadedImages extends CollectionImagesState {
  final List<String>? imageUrls;
  final Exception? exception;

  const CollectionImagesStateLoadedImages({
    required super.isLoading,
    required this.imageUrls,
    required this.exception,
  });
}
