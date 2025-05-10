import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:test/test.dart';

void main() async {
  final collectionService = CollectionStorage(
    firestore: FakeFirebaseFirestore(),
    imageStorage: MockFirebaseStorage(),
  );
  final ownerUserId = '123';

  group('Collection Storage Testing', () {
    test('Collections should be empty after creating new user', () async {
      final collections =
          await collectionService
              .allCollectionsByOwner(ownerUserId: ownerUserId)
              .first;
      expect(collections.isEmpty, isTrue);
    });

    test('Creating collection should return created collection', () async {
      final collection = await collectionService.createNewCollection(
        ownerUserId: ownerUserId,
        schedule: 'schedule',
        date: DateTime.now(),
        images: [],
        description: 'description',
        address: "'calle', 'numExt', 'numInt', 'colonia'",
        status: CollectionStatus.recibida,
        mode: 'mode',
      );
      expect(collection.ownerUserId, '123');
    });

    test('Collections should hold data after creating collection', () async {
      final collections =
          await collectionService
              .allCollectionsByOwner(ownerUserId: ownerUserId)
              .first;

      expect(collections.isNotEmpty, isTrue);

      final collection = collections.first;
      expect(collection, isNotNull);
      expect(collection.ownerUserId, '123');
    });

    test(
      'Collections of given users should not be accessible for other users',
      () async {
        final otherUserId = '124';
        final collections =
            await collectionService
                .allCollectionsByOwner(ownerUserId: otherUserId)
                .first;
        expect(collections.isEmpty, isTrue);
      },
    );

    test('Admin all collections should return all collections', () async {
      final collections = await collectionService.allCollections().first;
      expect(collections.isNotEmpty, isTrue);
    });

    test('Updating collection status should change status', () async {
      final collections = await collectionService.allCollections().first;
      final lastCollection = collections.first;
      await collectionService.updateCollectionStatus(
        documentId: lastCollection.documentId,
        status: CollectionStatus.lista,
      );

      final updatedCollections = await collectionService.allCollections().first;
      final updatedCollection = updatedCollections.first;

      expect(updatedCollection.status, isNot(lastCollection.status));
      expect(updatedCollection.status, CollectionStatus.lista);
    });
  });
}
