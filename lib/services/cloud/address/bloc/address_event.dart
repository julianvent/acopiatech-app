import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:flutter/cupertino.dart' show immutable;

@immutable
abstract class AddressEvent {
  const AddressEvent();
}

class AddressEventLoadAdresses extends AddressEvent {
  const AddressEventLoadAdresses();
}

class AddressEventLoadDropOffPoints extends AddressEvent {
  const AddressEventLoadDropOffPoints();
}


class AddressEventReturnToList extends AddressEvent {
  const AddressEventReturnToList();
}

class AddressEventCreateUpdateAddress extends AddressEvent {
  final Address? address;
  final String city;
  final String extNumber;
  final String? intNumber;
  final String neighborhood;
  final String? reference;
  final String state;
  final String street;
  final String zipCode;
  final String phoneNumber;

  const AddressEventCreateUpdateAddress(
    this.address,
    this.city,
    this.extNumber,
    this.intNumber,
    this.neighborhood,
    this.reference,
    this.state,
    this.street,
    this.zipCode,
    this.phoneNumber,
  );
}

class AddressEventShouldCreateUpdateAddress extends AddressEvent {
  final Address? address;
  const AddressEventShouldCreateUpdateAddress({required this.address});
}

class AddressEventDeleteAddress extends AddressEvent {
  final String documentId;
  const AddressEventDeleteAddress({required this.documentId});
}
