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

class AddressStateCreatingAddress extends AddressState {
  final Exception? exception;

  const AddressStateCreatingAddress({
    required super.isLoading,
    required this.exception,
  });
}

class AddressStateCreatedAdress extends AddressState {
  const AddressStateCreatedAdress({required super.isLoading});
}
