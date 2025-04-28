import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:acopiatech/services/cloud/storage_exceptions.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionStorage {
  // singleton
  CollectionStorage._sharedInstance();
  static final CollectionStorage _shared =
      CollectionStorage._sharedInstance();
  factory CollectionStorage() => _shared;

  final collections = FirebaseFirestore.instance.collection('collection');

  Stream<Iterable<Collection>> allCollections({
    required String ownerUserId,
  }) => collections.snapshots().map(
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
            (value) =>
                value.docs.map((doc) => Collection.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllCollectionsException();
    }
  }

  Future<Collection> createNewCollection({
    required String ownerUserId,
    required String description,
  }) async {
    final document = await collections.add({
      ownerUserIdFieldName: ownerUserId,
      timeCreatedFieldName: DateTime.timestamp(),
      collectionDateFieldName: DateTime.timestamp(),
      collectionScheduleFieldName: 'am',
      collectionEvidenceFieldName: 'fotos',
      collectionDescriptionFieldName: description,
      addressIdFieldName: 'address_id',
    });

    final fetchedCollection = await document.get();

    return Collection(
      documentId: fetchedCollection.id,
      ownerUserId: ownerUserId,
      timeCreated: DateTime.timestamp(),
      date: DateTime.timestamp(),
      schedule: 'am',
      evidence: 'fotos',
      description: description,
      addressId: 'address_id',
      stateId: 'state_id',
      mode: 'domicilio',
    );
  }
}
