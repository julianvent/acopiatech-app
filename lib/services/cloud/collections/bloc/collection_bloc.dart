import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc(CollectionStorage collectionService)
    : super(const CollectionStateUnintialized(isLoading: false)) {
      
    }
}
