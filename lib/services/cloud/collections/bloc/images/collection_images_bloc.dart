import 'package:acopiatech/services/cloud/collections/bloc/images/collection_images_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/images/collection_images_state.dart';
import 'package:acopiatech/services/cloud/collections/collection_image_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionImagesBloc
    extends Bloc<CollectionImagesEvent, CollectionImagesState> {
  CollectionImagesBloc(CollectionImageStorage imageService)
    : super(const CollectionImagesStateUnintialized(isLoading: false)) {
    on<CollectionImagesEventLoadImages>((event, emit) async {
      emit(
        CollectionImagesStateLoadedImages(
          isLoading: true,
          imageUrls: null,
          exception: null,
        ),
      );

      try {
        final imageUrls = await imageService.getImages(
          userId: event.ownerUserId,
          documentId: event.collectionId,
        );

        emit(
          CollectionImagesStateLoadedImages(
            isLoading: false,
            imageUrls: imageUrls,
            exception: null,
          ),
        );
      } on Exception catch (e) {
        emit(
          CollectionImagesStateLoadedImages(
            isLoading: false,
            imageUrls: null,
            exception: e,
          ),
        );
      }
    });
  }
}
