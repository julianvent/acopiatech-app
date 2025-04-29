import 'package:flutter/material.dart' show immutable;

@immutable
abstract class CollectionEvent {
  const CollectionEvent();
}

class CollectionEventLoadCollections extends CollectionEvent {
  const CollectionEventLoadCollections();
}

class CollectionEventCreateCollection extends CollectionEvent {
  final String schedule;
  final DateTime date;
  final String description;
  final String addressId;

  const CollectionEventCreateCollection({
    required this.schedule,
    required this.date,
    required this.description,
    required this.addressId,
  });
}
