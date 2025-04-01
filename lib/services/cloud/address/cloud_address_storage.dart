import 'package:acopiatech/services/cloud/address/cloud_address.dart';
import 'package:acopiatech/services/cloud/cloud_storage_constants.dart';
import 'package:acopiatech/services/cloud/cloud_storage_exceptions.dart';
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

  Future<CloudAddress> createNewAddress({
    required String ownerUserId,
    required String street,
    required String extNumber,
    required String? intNumber,
    required String neighborhood,
    required String zipCode,
    required String? reference,
    required String city,
    required String state,
  }) async {
    final document = await addresses.add({
      ownerUserIdFieldName: ownerUserId,
      addressStreetFieldName: street,
      addressExtNumberFieldName: extNumber,
      addressIntNumberFieldName: intNumber,
      addressNeighborhoodFieldName: neighborhood,
      addressZipCodeFieldName: zipCode,
      addressReferenceFieldName: reference,
      addressCityFieldName: city,
      addressStateFieldName: state,
      timeCreatedFieldName: DateTime.now(),
    });

    final fetchedAddress = await document.get();

    return CloudAddress(
      documentId: fetchedAddress.id,
      ownerUserId: ownerUserId,
      street: street,
      extNumber: extNumber,
      intNumber: intNumber,
      neighborhood: neighborhood,
      zipCode: zipCode,
      reference: reference,
      city: city,
      state: state,
      timeCreated: DateTime.now(),
    );
  }

  Future<void> deleteAddress({required String documentId}) async {
    try {
      await addresses.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteAddressException();
    }
  }
}
