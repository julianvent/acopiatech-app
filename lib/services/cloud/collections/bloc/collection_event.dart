import 'package:flutter/material.dart' show immutable;

@immutable
abstract class CollectionEvent {
  const CollectionEvent();
}

class CollectionEventLoadCollections extends CollectionEvent {
  const CollectionEventLoadCollections();
}

class CollectionEventCreateCollection extends CollectionEvent {
  final String description;

  const CollectionEventCreateCollection({required this.description});
}

