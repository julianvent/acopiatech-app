import 'dart:io';
import 'package:acopiatech/services/cloud/collections/collection_exception.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CollectionImageStorage {
  final rootReference = FirebaseStorage.instance.ref();

  Future<void> uploadImages({
    required List<String> imagesPath,
    required String userId,
    required String documentId,
  }) async {
    try {
      await Future.wait(
        imagesPath.map((path) async {
          File file = File(path);
          final fileName = path.split('/').last;


          final storageReference = rootReference.child(
            'collection/images/$userId/$documentId/$fileName',
          );

          await storageReference.putFile(file);
        }),
      );
    } on Exception {
      throw CouldNotUploadImageException();
    }
  }
}
