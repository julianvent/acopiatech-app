import 'package:acopiatech/utilities/enums/collection_status.dart';
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
  final List<String?> address;
  final CollectionStatus status;
  final String mode;

  const CollectionEventCreateCollection({
    required this.schedule,
    required this.date,
    required this.description,
    required this.images,
    required this.address,
    required this.status,
    required this.mode,
  });
}

class CollectionEventUpdateStatus extends CollectionEvent {
  final String documentId;
  final CollectionStatus status;

  const CollectionEventUpdateStatus({
    required this.documentId,
    required this.status,
  });
}
