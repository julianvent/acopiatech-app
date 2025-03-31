import 'package:acopiatech/services/cloud/address/cloud_address.dart';
import 'package:acopiatech/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudAddressStorage {
  CloudAddressStorage._sharedInstance();
  static final CloudAddressStorage _shared =
      CloudAddressStorage._sharedInstance();
  factory CloudAddressStorage() => _shared;

  final addresses = FirebaseFirestore.instance.collection('address');

  Stream<Iterable<CloudAddress>> allAddresses({required String ownerUserId}) =>
      addresses.snapshots().map(
        (event) => event.docs
            .map((doc) => CloudAddress.fromSnapshot(doc))
            .where((address) => address.ownerUserId == ownerUserId),
      );

  Future<CloudAddress> createNewAddress({required String ownerUserId}) async {
    final document = await addresses.add({
      ownerUserIdFieldName: ownerUserId,
      addressStreetFieldName: 'calle',
      addressExtNumberFieldName: '123',
      addressIntNumberFieldName: '',
      addressNeighborhoodFieldName: 'colonia',
      addressZipCodeFieldName: '12345',
      addressReferenceFieldName: '',
      addressCityFieldName: 'ciudad',
      addressStateFieldName: 'estado',
      timeCreatedFieldName: DateTime.now(),
    });

    final fetchedAddress = await document.get();

    return CloudAddress(
      documentId: fetchedAddress.id,
      ownerUserId: ownerUserId,
      street: 'calle',
      extNumber: '123',
      intNumber: '',
      neighborhood: 'colonia',
      zipCode: '12345',
      reference: '',
      city: 'ciudad',
      state: 'state',
      timeCreated: DateTime.now(),
    );
  }
}
