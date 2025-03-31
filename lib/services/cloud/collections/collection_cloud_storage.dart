import 'package:acopiatech/services/cloud/cloud_storage_constants.dart';
import 'package:acopiatech/services/cloud/cloud_storage_exceptions.dart';
import 'package:acopiatech/services/cloud/collections/cloud_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionsCloudStorage {
  // singleton
  CollectionsCloudStorage._sharedInstance();
  static final CollectionsCloudStorage _shared =
      CollectionsCloudStorage._sharedInstance();
  factory CollectionsCloudStorage() => _shared;

  final collections = FirebaseFirestore.instance.collection('collection');

  Stream<Iterable<CloudCollection>> allCollections({
    required String ownerUserId,
  }) => collections.snapshots().map(
    (event) => event.docs
        .map((doc) => CloudCollection.fromSnapshot(doc))
        .where((collection) => collection.ownerUserId == ownerUserId),
  );

  Future<Iterable<CloudCollection>> getCollections({
    required String ownerUserId,
  }) async {
    try {
      return await collections
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) =>
                value.docs.map((doc) => CloudCollection.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllCollectionsException();
    }
  }

  Future<CloudCollection> createNewCollection({
    required String ownerUserId,
    required String description,
  }) async {
    final document = await collections.add({
      ownerUserIdFieldName: ownerUserId,
      collectionDateCreatedFieldName: DateTime.timestamp(),
      collectionDateFieldName: DateTime.timestamp(),
      collectionScheduleFieldName: 'am',
      collectionEvidenceFieldName: 'fotos',
      collectionDescriptionFieldName: description,
      addressIdFieldName: 'address_id',
    });

    final fetchedCollection = await document.get();

    return CloudCollection(
      documentId: fetchedCollection.id,
      ownerUserId: ownerUserId,
      dateCreated: DateTime.timestamp(),
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
