import 'package:flutter/cupertino.dart' show immutable;

@immutable
abstract class AddressEvent {
  const AddressEvent();
}

class AddressEventCreateAddress extends AddressEvent {
  final String ownerUserId;
  final String city;
  final String extNumber;
  final String? intNumber;
  final String neighborhood;
  final String? reference;
  final String state;
  final String street;
  final String zipCode;

  const AddressEventCreateAddress(
    this.ownerUserId,
    this.city,
    this.extNumber,
    this.intNumber,
    this.neighborhood,
    this.reference,
    this.state,
    this.street,
    this.zipCode,
  );
}
