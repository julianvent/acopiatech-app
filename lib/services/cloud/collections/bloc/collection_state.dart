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

  const CollectionStateLoadedCollections({
    required this.collectionsStream,
    required super.isLoading,
  });
}

class CollectionStateCreatingCollection extends CollectionState {
  final Exception? exception;

  const CollectionStateCreatingCollection({
    required super.isLoading,
    required this.exception,
  });
}
