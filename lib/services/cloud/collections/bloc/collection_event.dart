import 'package:flutter/material.dart' show immutable;
import 'package:image_picker/image_picker.dart';

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
