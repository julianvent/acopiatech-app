import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CloudStorage {
  CollectionReference<Map<String, dynamic>> collection(
    FirebaseFirestore instance,
  );
}
