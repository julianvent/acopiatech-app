import 'dart:developer';

import 'package:acopiatech/services/auth/auth_service.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(AddressStorage addressService)
    : super(const AddressStateUnintialized(isLoading: false)) {
    Future<void> emitUpdateAddressList(Emitter<AddressState> emit) async {
      final currentUser = await AuthService.firebase().currentUser;
      final addressesStream = addressService.allAddresses(
        ownerUserId: currentUser!.id,
      );
      emit(
        AddressStateLoadedAddress(
          addressesStream: addressesStream,
          isLoading: false,
        ),
      );
    }

    on<AddressEventLoadAdresses>((event, emit) async {
      emit(AddressStateLoadedAddress(addressesStream: null, isLoading: true));
      await emitUpdateAddressList(emit);
    });

    on<AddressEventShouldCreateUpdateAddress>((event, emit) {
      emit(
        AddressStateCreatingUpdatingAddress(
          address: event.address,
          isLoading: false,
          exception: null,
        ),
      );
    });

    on<AddressEventCreateUpdateAddress>((event, emit) async {
      final address = event.address;
      emit(
        AddressStateCreatingUpdatingAddress(
          address: address,
          isLoading: true,
          exception: null,
        ),
      );

      if (address != null) {
        try {
          await addressService.updateAddress(
            documentId: address.documentId,
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
        } on Exception catch (e) {
          emit(
            AddressStateCreatingUpdatingAddress(
              address: address,
              isLoading: false,
              exception: e,
            ),
          );
        }
      } else {
        try {
          final currentUser = await AuthService.firebase().currentUser;
          await addressService.createNewAddress(
            ownerUserId: currentUser!.id,
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
        } on Exception catch (e) {
          emit(
            AddressStateCreatingUpdatingAddress(
              address: null,
              isLoading: false,
              exception: e,
            ),
          );
        }
      }

      await emitUpdateAddressList(emit);
    });

    on<AddressEventReturnToList>((event, emit) {
      emit(AddressStateListAddresses(isLoading: false));
    });

    on<AddressEventDeleteAddress>((event, emit) async {
      emit(AddressStateDeletingAddress(exception: null, isLoading: true));

      final documentId = event.documentId;

      try {
        await addressService.deleteAddress(documentId: documentId);
      } on Exception catch (e) {
        emit(AddressStateDeletingAddress(exception: e, isLoading: false));
      }
      await emitUpdateAddressList(emit);
    });
  }
}
