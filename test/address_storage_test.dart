import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:test/test.dart';

void main() async {
  final addressStorage = AddressStorage(firestore: FakeFirebaseFirestore());

  group('Address Storage Testing', () {
    test('Creating address should return new address', () async {
      final address = await addressStorage.createNewAddress(
        ownerUserId: '123',
        street: 'street',
        extNumber: 'extNumber',
        intNumber: 'intNumber',
        neighborhood: 'neighborhood',
        zipCode: 'zipCode',
        phoneNumber: 'phoneNumber',
        reference: 'reference',
        city: 'city',
        state: 'state',
      );

      expect(address.ownerUserId, '123');
    });
  });
}
