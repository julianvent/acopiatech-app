import 'package:flutter/material.dart' show immutable;

@immutable
abstract class CollectionEvent {
  const CollectionEvent();
}

class CollectionEventLoadCollections extends CollectionEvent {
  const CollectionEventLoadCollections();
}

class CollectionEventLoadLastCollection extends CollectionEvent {
  const CollectionEventLoadLastCollection();
}

class CollectionEventCreateCollection extends CollectionEvent {
  final String schedule;
  final DateTime date;
  final List<String> images;
  final String description;
  final String addressId;

  const CollectionEventCreateCollection({
    required this.schedule,
    required this.date,
    required this.description,
    required this.images,
    required this.addressId,
  });
}
