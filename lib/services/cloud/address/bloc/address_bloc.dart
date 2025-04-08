import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/cloud_address_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(AuthUser currentUser, CloudAddressStorage addressService)
    : super(const AddressStateUnintialized(isLoading: false)) {
    void emitUpdateAddressList(Emitter<AddressState> emit) {
      final addressesStream = addressService.allAddresses(
        ownerUserId: currentUser.id,
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
      emitUpdateAddressList(emit);
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

      emitUpdateAddressList(emit);
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
      emitUpdateAddressList(emit);
    });
  }
}
