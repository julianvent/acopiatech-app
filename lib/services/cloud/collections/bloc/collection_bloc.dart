import 'package:acopiatech/services/auth/auth_service.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc(CollectionStorage collectionService)
    : super(const CollectionStateUnintialized(isLoading: false)) {
    on<CollectionEventLoadCollections>((event, emit) async {
      emit(
        CollectionStateLoadedCollections(
          collectionsStream: null,
          lastCollection: null,
          isLoading: true,
        ),
      );
      final currentUser = await AuthService.firebase().currentUser;
      final collectionsStream = collectionService.allCollections(
        ownerUserId: currentUser!.id,
      );

      final lastCollection = await collectionService.getLastCollection(
        ownerUserId: currentUser.id,
      );

      emit(
        CollectionStateLoadedCollections(
          collectionsStream: collectionsStream,
          lastCollection: lastCollection,
          isLoading: false,
        ),
      );
    });

    on<CollectionEventLoadLastCollection>((event, emit) async {
      emit(
        CollectionStateLoadedLastCollection(collection: null, isLoading: true),
      );

      final currentUser = await AuthService.firebase().currentUser;
      final lastCollection = await collectionService.getLastCollection(
        ownerUserId: currentUser!.id,
      );
      
      emit(
        CollectionStateLoadedLastCollection(
          collection: lastCollection,
          isLoading: false,
        ),
      );
    });

    on<CollectionEventCreateCollection>((event, emit) async {
      emit(CollectionStateCreatingCollection(isLoading: true, exception: null));
      final currentUser = await AuthService.firebase().currentUser;
      try {
        await collectionService.createNewCollection(
          ownerUserId: currentUser!.id,
          schedule: event.schedule,
          date: event.date,
          description: event.description,
          images: event.images,
          addressId: event.addressId,
        );
        emit(
          CollectionStateCreatingCollection(isLoading: false, exception: null),
        );
      } on Exception catch (e) {
        emit(CollectionStateCreatingCollection(isLoading: false, exception: e));
      }
    });
  }
}
