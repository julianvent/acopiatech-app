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
          ongoingCollectionsStream: null,
          isLoading: true,
          exception: null,
        ),
      );

      final currentUser = await AuthService.firebase().currentUser;
      final userId = currentUser!.id;
      final userRole = currentUser.role ?? 'user';

      try {
        final collectionsStream =
            userRole == 'admin'
                ? collectionService.allCollections()
                : collectionService.allCollectionsByOwner(ownerUserId: userId);

        final lastCollection = await collectionService.getLastOngoingCollection(
          ownerUserId: userId,
        );

        final ongoingCollectionsStream = collectionService
            .allUserOngoingCollections(ownerUserId: userId);

        emit(
          CollectionStateLoadedCollections(
            collectionsStream: collectionsStream,
            lastCollection: lastCollection,
            ongoingCollectionsStream: ongoingCollectionsStream,
            isLoading: false,
            exception: null,
          ),
        );
      } on Exception catch (e) {
        emit(
          CollectionStateLoadedCollections(
            collectionsStream: null,
            lastCollection: null,
            ongoingCollectionsStream: null,
            isLoading: false,
            exception: e,
          ),
        );
      }
    });

    on<CollectionEventLoadLastCollection>((event, emit) async {
      emit(
        CollectionStateLoadedLastCollection(collection: null, isLoading: true),
      );

      final currentUser = await AuthService.firebase().currentUser;
      final lastCollection = await collectionService.getLastOngoingCollection(
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
          address: event.address,
          status: event.status,
          mode: event.mode,
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
