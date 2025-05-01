import 'package:flutter/material.dart' show immutable;

@immutable
abstract class CollectionImagesEvent {
  const CollectionImagesEvent();
}

class CollectionImagesEventLoadImages extends CollectionImagesEvent {
  final String ownerUserId;
  final String collectionId;

  const CollectionImagesEventLoadImages({
    required this.ownerUserId,
    required this.collectionId,
  });
}
