import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String documentId;
  final String ownerUserId;
  final String city;
  final String extNumber;
  final String? intNumber;
  final String neighborhood;
  final String? reference;
  final String state;
  final String street;
  final String zipCode;
  final DateTime timeCreated;
  final String phoneNumber;
  final bool isDeleted;
  final bool? isDropOff;

  const Address({
    required this.documentId,
    required this.ownerUserId,
    required this.street,
    required this.extNumber,
    required this.intNumber,
    required this.neighborhood,
    required this.zipCode,
    required this.phoneNumber,
    required this.reference,
    required this.city,
    required this.state,
    required this.timeCreated,
    required this.isDeleted,
    required this.isDropOff,
  });

  Address.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : documentId = snapshot.id,
      ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
      street = snapshot.data()[addressStreetFieldName] as String,
      extNumber = snapshot.data()[addressExtNumberFieldName] as String,
      intNumber = snapshot.data()[addressIntNumberFieldName] as String,
      neighborhood = snapshot.data()[addressNeighborhoodFieldName] as String,
      zipCode = snapshot.data()[addressZipCodeFieldName] as String,
      phoneNumber = snapshot.data()[addressPhoneNumberFieldName] as String,
      reference = snapshot.data()[addressReferenceFieldName] as String,
      city = snapshot.data()[addressCityFieldName] as String,
      state = snapshot.data()[addressStateFieldName] as String,
      timeCreated =
          (snapshot.data()[timeCreatedFieldName] as Timestamp).toDate(),
      isDeleted = snapshot.data()[addressIsDeletedFieldName] as bool,
      isDropOff = snapshot.data()[addressIsDropOffFieldName] as bool;

  @override
  String toString() {
    String number = '$extNumber $intNumber'.trim();
    return "$street $number, $neighborhood, $zipCode $city, ${state.length > 3 ? state.substring(0, 3) : state}.";
  }
}
