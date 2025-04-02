import 'dart:async';
import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/cloud_address.dart';
import 'package:acopiatech/services/cloud/address/cloud_address_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(AuthUser currentUser, CloudAddressStorage addressService)
    : super(const AddressStateUnintialized(isLoading: false)) {
    on<AddressEventLoadAdresses>((event, emit) async {
      emit(AddressStateLoadedAddress(addressesStream: null, isLoading: true));

      Stream<Iterable<CloudAddress>> addressesStream = addressService
          .allAddresses(ownerUserId: currentUser.id);

      emit(
        AddressStateLoadedAddress(
          addressesStream: addressesStream,
          isLoading: false,
        ),
      );
    });

    on<AddressEventShouldCreateAddress>((event, emit) {
      emit(AddressStateCreatingAddress(isLoading: false, exception: null));
    });

    on<AddressEventCreateAddress>((event, emit) async {
      emit(AddressStateCreatingAddress(isLoading: true, exception: null));
      try {
        await addressService.createNewAddress(
          ownerUserId: currentUser.id,
          street: event.street,
          extNumber: event.extNumber,
          intNumber: event.intNumber,
          neighborhood: event.neighborhood,
          zipCode: event.zipCode,
          phoneNumber: event.phoneNumber,
          reference: event.reference,
          city: event.city,
          state: event.state,
        );
        Stream<Iterable<CloudAddress>> addressesStream = addressService
            .allAddresses(ownerUserId: currentUser.id);

        emit(
          AddressStateLoadedAddress(
            addressesStream: addressesStream,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(AddressStateCreatingAddress(isLoading: false, exception: e));
      }
    });

    on<AddressEventReturnToList>((event, emit) {
      emit(AddressStateListAddresses(isLoading: false));
    });
  }
}
