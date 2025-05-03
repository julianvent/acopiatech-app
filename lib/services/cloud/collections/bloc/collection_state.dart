import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
abstract class CollectionState {
  final bool isLoading;
  final String? loadingText;

  const CollectionState({
    required this.isLoading,
    this.loadingText = 'Por favor espere un momento...',
  });
}

class CollectionStateUnintialized extends CollectionState {
  const CollectionStateUnintialized({required super.isLoading});
}

class CollectionStateLoadedCollections extends CollectionState {
  final Stream<Iterable<Collection>>? collectionsStream;
  final Collection? lastCollection;
  final Stream<Iterable<Collection>>? ongoingCollectionsStream;
  final Exception? exception;

  const CollectionStateLoadedCollections({
    required this.collectionsStream,
    required this.lastCollection,
    required this.ongoingCollectionsStream,
    required super.isLoading,
    required this.exception,
  });
}

class CollectionStateLoadedLastCollection extends CollectionState {
  final Collection? collection;

  const CollectionStateLoadedLastCollection({
    required this.collection,
    required super.isLoading,
    super.loadingText,
  });
}

class CollectionStateCreatingCollection extends CollectionState {
  final Exception? exception;

  const CollectionStateCreatingCollection({
    required super.isLoading,
    required this.exception,
  });
}

class CollectionStateUpdatingCollection extends CollectionState {
  final Exception? exception;

  const CollectionStateUpdatingCollection({
    required super.isLoading,
    required this.exception,
    super.loadingText = 'Actualizando recolección...'
  });
}
