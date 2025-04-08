import 'package:acopiatech/services/cloud/address/cloud_address.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AddressState {
  final bool isLoading;
  final String? loadingText;

  const AddressState({
    required this.isLoading,
    this.loadingText = 'Por favor espere un momento...',
  });
}

class AddressStateUnintialized extends AddressState {
  const AddressStateUnintialized({required super.isLoading});
}

class AddressStateLoadedAddress extends AddressState {
  final Stream<Iterable<CloudAddress>>? addressesStream;
  const AddressStateLoadedAddress({
    required this.addressesStream,
    required super.isLoading,
  });
}

class AddressStateCreatingUpdatingAddress extends AddressState {
  final CloudAddress? address;
  final Exception? exception;

  const AddressStateCreatingUpdatingAddress({
    required this.address,
    required super.isLoading,
    required this.exception,
  });
}

class AddressStateCreatedAddress extends AddressState {
  const AddressStateCreatedAddress({required super.isLoading});
}

class AddressStateListAddresses extends AddressState {
  const AddressStateListAddresses({required super.isLoading});
}

class AddressStateUpdatingAddress extends AddressState {
  final CloudAddress? address;
  final Exception? exception;

  const AddressStateUpdatingAddress({
    required this.address,
    required this.exception,
    required super.isLoading,
  });
}

class AddressStateDeletingAddress extends AddressState {
  final Exception? exception;
  const AddressStateDeletingAddress({
    required this.exception,
    required super.isLoading,
  });
}
