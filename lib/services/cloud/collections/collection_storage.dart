import 'package:acopiatech/services/cloud/collections/collection_exception.dart';
import 'package:acopiatech/services/cloud/collections/collection_image_storage.dart';
import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:acopiatech/services/cloud/storage_exceptions.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CollectionStorage {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _imageStorage;

  CollectionStorage._sharedInstance(this._firestore, this._imageStorage);
  static CollectionStorage? _shared;

  factory CollectionStorage({
    FirebaseFirestore? firestore,
    FirebaseStorage? imageStorage,
  }) {
    _shared ??= CollectionStorage._sharedInstance(
      firestore ?? FirebaseFirestore.instance,
      imageStorage ?? FirebaseStorage.instance,
    );
    return _shared!;
  }

  CollectionReference<Map<String, dynamic>> get collections =>
      _firestore.collection('collection');

  CollectionImageStorage get imageStorage =>
      CollectionImageStorage(storage: _imageStorage);

  Stream<Iterable<Collection>> allCollections() {
    return collections
        .orderBy(timeCreatedFieldName, descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => Collection.fromSnapshot(doc)));
  }

  Stream<Iterable<Collection>> allCollectionsByOwner({
    required String ownerUserId,
  }) {
    return collections
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .orderBy(timeCreatedFieldName, descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => Collection.fromSnapshot(doc)));
  }

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
    required List<String?> address,
    required CollectionStatus status,
    required String mode,
  }) async {
    final timeCreated = DateTime.timestamp();

    try {
      final document = await collections.add({
        ownerUserIdFieldName: ownerUserId,
        timeCreatedFieldName: timeCreated,
        collectionScheduleFieldName: schedule,
        collectionDateFieldName: date,
        collectionDescriptionFieldName: description,
        addressFieldName: address,
        collectionStatusFieldName: status.name,
        collectionModeFieldName: mode,
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
        schedule: schedule,
        description: description,
        address: address,
        status: status,
        mode: mode,
      );
    } on Exception {
      throw CouldNotCreateCollectionException();
    }
  }

  Future<Collection?> getLastOngoingCollection({
    required String ownerUserId,
  }) async {
    try {
      final Iterable<Collection?> querySnapshot = await collections
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .where(collectionStatusFieldName, isNotEqualTo: 'Cancelada')
          .orderBy(timeCreatedFieldName, descending: true)
          .limit(1)
          .get()
          .then(
            (value) => value.docs.map((doc) => Collection.fromSnapshot(doc)),
          );

      // return last collection
      if (querySnapshot.isNotEmpty) {
        return querySnapshot.first;
      }
      return null;
    } on Exception {
      throw CouldNotGetCollectionException();
    }
  }

  Stream<Iterable<Collection>> allUserOngoingCollections({
    required String ownerUserId,
  }) => collections
      .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .where(
        collectionStatusFieldName,
        isEqualTo: CollectionStatus.enCamino.name,
      )
      .orderBy(timeCreatedFieldName, descending: true)
      .snapshots()
      .map((event) => event.docs.map((doc) => Collection.fromSnapshot(doc)));

  Future<void> updateCollectionStatus({
    required String documentId,
    required CollectionStatus status,
  }) async {
    try {
      await collections.doc(documentId).update({
        collectionStatusFieldName: status.name,
      });
    } on Exception {
      throw CouldNotUpdateCollectionException();
    }
  }
}
