import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Collection {
  final String documentId;
  final String ownerUserId;
  final DateTime timeCreated;
  final DateTime date;
  final String schedule;
  final String description;
  final String addressId;
  final String stateId;
  final String mode;

  const Collection({
    required this.documentId,
    required this.ownerUserId,
    required this.timeCreated,
    required this.date,
    required this.schedule,
    required this.description,
    required this.addressId,
    required this.stateId,
    required this.mode
  });

  Collection.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) : documentId = snapshot.id,
      ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
      timeCreated = (snapshot.data()[timeCreatedFieldName] as Timestamp).toDate(),
      date = (snapshot.data()[collectionDateFieldName] as Timestamp).toDate(),
      schedule = snapshot.data()[collectionScheduleFieldName] as String,
      description = snapshot.data()[collectionDescriptionFieldName] as String,
      addressId = snapshot.data()[addressIdFieldName] as String,
      stateId = snapshot.data()[collectionStateIdFieldName] as String,
      mode = snapshot.data()[collectionModeIdFieldName] as String;
}
