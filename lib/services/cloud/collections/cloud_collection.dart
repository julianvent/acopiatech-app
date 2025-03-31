import 'package:acopiatech/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class CloudCollection {
  final String documentId;
  final String ownerUserId;
  final DateTime dateCreated;
  final DateTime date;
  final String schedule;
  final String evidence;
  final String description;
  final String addressId;
  final String stateId;
  final String mode;

  const CloudCollection({
    required this.documentId,
    required this.ownerUserId,
    required this.dateCreated,
    required this.date,
    required this.schedule,
    required this.evidence,
    required this.description,
    required this.addressId,
    required this.stateId,
    required this.mode
  });

  CloudCollection.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) : documentId = snapshot.id,
      ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
      dateCreated = (snapshot.data()[collectionDateCreatedFieldName] as Timestamp).toDate(),
      date = (snapshot.data()[collectionDateFieldName] as Timestamp).toDate(),
      schedule = snapshot.data()[collectionScheduleFieldName] as String,
      evidence = snapshot.data()[collectionEvidenceFieldName] as String,
      description = snapshot.data()[collectionDescriptionFieldName] as String,
      addressId = snapshot.data()[addressIdFieldName] as String,
      stateId = snapshot.data()[collectionStateIdFieldName] as String,
      mode = snapshot.data()[collectionModeIdFieldName] as String;
}
