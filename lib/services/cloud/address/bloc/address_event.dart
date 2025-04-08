import 'package:acopiatech/services/cloud/address/cloud_address.dart';
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

class AddressEventCreateUpdateAddress extends AddressEvent {
  final CloudAddress? address;
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
  final CloudAddress? address;
  const AddressEventShouldCreateUpdateAddress({required this.address});
}
