import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:test/test.dart';

void main() async {
  final collectionService = CollectionStorage(
    firestore: FakeFirebaseFirestore(),
  );
  final ownerUserId = '123';

  group('Collection Storage Testing', () {
    test('Collections should be empty after creating new user', () async {
      final collections = await collectionService.allCollectionsByOwner(ownerUserId: ownerUserId).first;
      expect(collections.isEmpty, isTrue);
    });
  });
}