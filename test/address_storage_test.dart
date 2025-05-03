import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:test/test.dart';

void main() async {
  final addressService = AddressStorage(firestore: FakeFirebaseFirestore());
  final ownerUserId = '123';

  group('Address Storage Testing', () {
    test('Addresses should be empty after creating new user', () async {
      final stream = addressService.allAddressesByOwner(
        ownerUserId: ownerUserId,
      );

      final addresses = await stream.first;
      expect(addresses.isEmpty, isTrue);
    });

    test('Creating address should return new address', () async {
      final address = await addressService.createNewAddress(
        ownerUserId: ownerUserId,
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

    test('Addresses should hold data after creating address', () async {
      final stream = addressService.allAddressesByOwner(
        ownerUserId: ownerUserId,
      );

      final addresses = await stream.first;

      expect(addresses.isNotEmpty, isTrue);
      // check if address holds data
      expect(addresses.first.ownerUserId, ownerUserId);
    });

    test('Updating addresses should modify address fields', () async {
      // get created address
      final addresses =
          await addressService
              .allAddressesByOwner(ownerUserId: ownerUserId)
              .first;

      final originalAddress = addresses.first;
      final originalAddressStreet = originalAddress.street;

      final newStreet = 'new Street';

      await addressService.updateAddress(
        documentId: originalAddress.documentId,
        street: newStreet,
        extNumber: 'extNumber',
        neighborhood: 'neighborhood',
        intNumber: 'intNumber',
        zipCode: 'zipCode',
        phoneNumber: 'phoneNumber',
        reference: 'reference',
        city: 'city',
        state: 'state',
      );

      final updatedAddresses =
          await addressService
              .allAddressesByOwner(ownerUserId: ownerUserId)
              .first;

      final updatedAddress = updatedAddresses.first;

      expect(updatedAddress.street, isNot(originalAddressStreet));
      expect(updatedAddress.street, newStreet);
    });

    test('Deleting address should mark as address as deleted', () async {
      // get created address
      final addresses =
          await addressService
              .allAddressesByOwner(ownerUserId: ownerUserId)
              .first;

      final address = addresses.first;

      expect(address.isDeleted, isFalse);

      addressService.deleteAddress(documentId: address.documentId);

      final updatedAddresses =
          await addressService
              .allAddressesByOwner(ownerUserId: ownerUserId)
              .first;

      expect(updatedAddresses.isEmpty, isTrue);
    });
  });
}
