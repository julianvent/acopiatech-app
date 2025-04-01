import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/cloud_address_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(AuthUser currentUser, CloudAddressStorage addressService)
    : super(const AddressStateUnintialized(isLoading: false)) {
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
          reference: event.reference,
          city: event.city,
          state: event.state,
        );
        emit(AddressStateCreatedAdress(isLoading: false));
      } on Exception catch (e) {
        emit(AddressStateCreatingAddress(isLoading: false, exception: e));
      }
    });
  }
}
