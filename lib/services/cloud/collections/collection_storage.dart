import 'package:acopiatech/services/cloud/collections/collection_exception.dart';
import 'package:acopiatech/services/cloud/collections/collection_image_storage.dart';
import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:acopiatech/services/cloud/storage_exceptions.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionStorage {
  // singleton
  CollectionStorage._sharedInstance();
  static final CollectionStorage _shared = CollectionStorage._sharedInstance();
  factory CollectionStorage() => _shared;

  final collections = FirebaseFirestore.instance.collection('collection');
  final CollectionImageStorage imageStorage = CollectionImageStorage();

  Stream<Iterable<Collection>> allCollections({required String ownerUserId}) =>
      collections.snapshots().map(
        (event) => event.docs
            .map((doc) => Collection.fromSnapshot(doc))
            .where((collection) => collection.ownerUserId == ownerUserId),
      );

  Future<Iterable<Collection>> getCollections({
    required String ownerUserId,
  }) async {
    try {
      return await collections
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => Collection.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllCollectionsException();
    }
  }

  Future<Collection> createNewCollection({
    required String ownerUserId,
    required String schedule,
    required DateTime date,
    required List<String> images,
    required String description,
    required String addressId,
  }) async {
    final timeCreated = DateTime.timestamp();

    try {
      final document = await collections.add({
        ownerUserIdFieldName: ownerUserId,
        timeCreatedFieldName: timeCreated,
        collectionScheduleIdFieldName: schedule,
        collectionDateFieldName: date,
        collectionDescriptionFieldName: description,
        addressIdFieldName: addressId,
        collectionStateIdFieldName: '1',
        collectionModeIdFieldName: '1',
      });

      final fetchedCollection = await document.get();

      try {
        await imageStorage.uploadImages(
          imagesPath: images,
          documentId: fetchedCollection.id,
          userId: ownerUserId,
        );
      } on Exception {
        throw CouldNotCreateCollectionException();
      }

      return Collection(
        documentId: fetchedCollection.id,
        ownerUserId: ownerUserId,
        timeCreated: timeCreated,
        dateScheduled: date,
        scheduleId: schedule,
        description: description,
        addressId: addressId,
        stateId: 'state_id',
        modeId: 'domicilio',
      );
    } on Exception {
      throw CouldNotCreateCollectionException();
    }
  }
}
