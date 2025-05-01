import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Collection {
  final String documentId;
  final String ownerUserId;
  final DateTime timeCreated;
  final DateTime dateScheduled;
  final String scheduleId;
  final String description;
  final List<String> address;
  final String stateId;
  final String modeId;

  const Collection({
    required this.documentId,
    required this.ownerUserId,
    required this.timeCreated,
    required this.dateScheduled,
    required this.scheduleId,
    required this.description,
    required this.address,
    required this.stateId,
    required this.modeId,
  });

  Collection.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : documentId = snapshot.id,
      ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
      timeCreated =
          (snapshot.data()[timeCreatedFieldName] as Timestamp).toDate(),
      dateScheduled =
          (snapshot.data()[collectionDateFieldName] as Timestamp).toDate(),
      scheduleId = snapshot.data()[collectionScheduleIdFieldName] as String,
      description = snapshot.data()[collectionDescriptionFieldName] as String,
      address = snapshot.data()[addressFieldName] as List<String>,
      stateId = snapshot.data()[collectionStateIdFieldName] as String,
      modeId = snapshot.data()[collectionModeIdFieldName] as String;
}
