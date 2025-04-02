import 'package:flutter/cupertino.dart' show immutable;

@immutable
abstract class AddressEvent {
  const AddressEvent();
}

class AddressEventLoadAdresses extends AddressEvent {
  const AddressEventLoadAdresses();
}

class AddressEventReturnToList extends AddressEvent {
  const AddressEventReturnToList();
}

class AddressEventCreateAddress extends AddressEvent {
  final String city;
  final String extNumber;
  final String? intNumber;
  final String neighborhood;
  final String? reference;
  final String state;
  final String street;
  final String zipCode;
  final String phoneNumber;

  const AddressEventCreateAddress(
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

class AddressEventShouldCreateAddress extends AddressEvent {
  const AddressEventShouldCreateAddress();
}
