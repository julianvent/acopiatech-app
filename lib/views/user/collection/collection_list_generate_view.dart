import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:flutter/material.dart';

typedef CollectionCallback = void Function(Collection collection);

class CollectionListGenerateView extends StatelessWidget {
  final Iterable<Collection> collections;
  final int length;
  final CollectionCallback onTap;
  final CollectionStatus? statusFilter;
  final int? dayFilter;
  final String? noCollectionText;

  const CollectionListGenerateView({
    super.key,
    required this.collections,
    required this.length,
    required this.onTap,
    this.statusFilter,
    this.dayFilter,
    this.noCollectionText,
  });

  @override
  Widget build(BuildContext context) {
    List<Collection> filteredCollections =
        collections.where((collection) {
          bool matchesStatus =
              statusFilter == null || collection.status == statusFilter;
          bool matchesDate =
              dayFilter == null || collection.dateScheduled.day == dayFilter;

          return matchesStatus && matchesDate;
        }).toList();

    if (filteredCollections.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          child: Text(
            noCollectionText ?? 'No cuentas con recolecciones.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      spacing: 10,
      children: List.generate(
        length > filteredCollections.length
            ? filteredCollections.length
            : length,
        (index) {
          final collection = filteredCollections.elementAt(index);

          // date
          final date =
              '${collection.dateScheduled.day}-${collection.dateScheduled.month}-${collection.dateScheduled.year} ${collection.schedule}';

          // get current status
          final Color statusColor = collection.status.color;

          return Card(
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 1,
                  left: 1,
                  right: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () => onTap(collection),
                      title: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Text(
                              collection.mode,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.circle, color: statusColor),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        spacing: 10,
                        children: [
                          Row(
                            children: [
                              Text(
                                collection.status.status,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [Icon(Icons.date_range), Text(date)],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.location_on),
                              Flexible(
                                child: Text(
                                  collection.address,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible:
                                collection.status ==
                                CollectionStatus.finalizada,
                            child: Row(
                              children: [
                                Text('Puntos asignados: '),
                                Text(collection.pointsEarned.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
