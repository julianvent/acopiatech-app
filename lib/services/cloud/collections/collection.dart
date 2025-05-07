import 'package:acopiatech/services/cloud/storage_constants.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Collection {
  final String documentId;
  final String ownerUserId;
  final DateTime timeCreated;
  final DateTime dateScheduled;
  final String schedule;
  final String description;
  final List<String?> address;
  final CollectionStatus status;
  final String mode;
  final int? pointsEarned;

  const Collection({
    required this.documentId,
    required this.ownerUserId,
    required this.timeCreated,
    required this.dateScheduled,
    required this.schedule,
    required this.description,
    required this.address,
    required this.status,
    required this.mode,
    this.pointsEarned = 0,
  });

  Collection.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : documentId = snapshot.id,
      ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
      timeCreated =
          (snapshot.data()[timeCreatedFieldName] as Timestamp).toDate(),
      dateScheduled =
          (snapshot.data()[collectionDateFieldName] as Timestamp).toDate(),
      schedule = snapshot.data()[collectionScheduleFieldName] as String,
      description = snapshot.data()[collectionDescriptionFieldName] as String,
      address = List<String?>.from(snapshot.data()[addressFieldName]),
      status = CollectionStatus.values.firstWhere(
        (status) =>
            status.name == snapshot.data()[collectionStatusFieldName] as String,
      ),
      mode = snapshot.data()[collectionModeFieldName] as String,
      pointsEarned = snapshot.data()[collectionPointsFieldName] as int? ?? 0;
}
