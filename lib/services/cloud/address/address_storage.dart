import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:acopiatech/services/cloud/storage_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressStorage {
  final FirebaseFirestore _firestore;

  AddressStorage._sharedInstance(this._firestore);

  static AddressStorage? _shared;

  factory AddressStorage({FirebaseFirestore? firestore}) {
    _shared ??= AddressStorage._sharedInstance(
      firestore ?? FirebaseFirestore.instance,
    );
    return _shared!;
  }

  CollectionReference<Map<String, dynamic>> get addresses =>
      _firestore.collection('address');

  Stream<Iterable<Address>> allAddressesByOwner({required String ownerUserId}) =>
      addresses
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .where(addressIsDeletedFieldName, isEqualTo: false)
          .snapshots()
          .map((event) => event.docs.map((doc) => Address.fromSnapshot(doc)));

  Future<Address> createNewAddress({
    required String ownerUserId,
    required String street,
    required String extNumber,
    required String? intNumber,
    required String neighborhood,
    required String zipCode,
    required String phoneNumber,
    required String? reference,
    required String city,
    required String state,
  }) async {
    try {
      final timeCreated = DateTime.now();
      final document = await addresses.add({
        ownerUserIdFieldName: ownerUserId,
        addressStreetFieldName: street,
        addressExtNumberFieldName: extNumber,
        addressIntNumberFieldName: intNumber,
        addressNeighborhoodFieldName: neighborhood,
        addressZipCodeFieldName: zipCode,
        addressPhoneNumberFieldName: phoneNumber,
        addressReferenceFieldName: reference,
        addressCityFieldName: city,
        addressStateFieldName: state,
        timeCreatedFieldName: timeCreated,
        addressIsDeletedFieldName: false,
      });

      final fetchedAddress = await document.get();

      return Address(
        documentId: fetchedAddress.id,
        ownerUserId: ownerUserId,
        street: street,
        extNumber: extNumber,
        intNumber: intNumber,
        neighborhood: neighborhood,
        zipCode: zipCode,
        phoneNumber: phoneNumber,
        reference: reference,
        city: city,
        state: state,
        timeCreated: timeCreated,
        isDeleted: false,
      );
    } catch (e) {
      throw CouldNotCreateAddressException();
    }
  }

  Future<void> deleteAddress({required String documentId}) async {
    try {
      await addresses.doc(documentId).update({addressIsDeletedFieldName: true});
    } catch (e) {
      throw CouldNotDeleteAddressException();
    }
  }

  Future<void> updateAddress({
    required String documentId,
    required String street,
    required String extNumber,
    String? intNumber,
    required String neighborhood,
    required String zipCode,
    required String phoneNumber,
    String? reference,
    required String city,
    required String state,
  }) async {
    try {
      await addresses.doc(documentId).update({
        addressStreetFieldName: street,
        addressExtNumberFieldName: extNumber,
        addressIntNumberFieldName: intNumber,
        addressNeighborhoodFieldName: neighborhood,
        addressZipCodeFieldName: zipCode,
        addressPhoneNumberFieldName: phoneNumber,
        addressReferenceFieldName: reference,
        addressCityFieldName: city,
        addressStateFieldName: state,
      });
    } catch (e) {
      throw CouldNotUpdateAddressException();
    }
  }
}
