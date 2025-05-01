import 'dart:io';
import 'package:acopiatech/services/cloud/collections/collection_exception.dart';
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

  Future<List<String>> getImages({
    required String userId,
    required String documentId,
  }) async {
    
    try {
      final storageReference = rootReference.child(
        'collection/images/$userId/$documentId',
      );

      final ListResult result = await storageReference.listAll();
      
      final List<String> imageUrls = await Future.wait(
        result.items.map((item) async {
          // Obtenemos las URLs públicas de las imágenes
          final String downloadUrl = await item.getDownloadURL();
          return downloadUrl;
        }).toList(),
      );

      return imageUrls;
    } on Exception {
      throw CouldNotGetImageException();
    }
  }

}

class CouldNotGetImageException implements Exception {
  final String message;

  CouldNotGetImageException([this.message = 'Could not get images.']);

  @override
  String toString() => 'CouldNotGetImageException: $message';
}
