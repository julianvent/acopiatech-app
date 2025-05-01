import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:flutter/material.dart';

typedef CollectionCallback = void Function(Collection collection);

class CollectionListGenerateView extends StatelessWidget {
  final Iterable<Collection> collections;
  final int length;
  final CollectionCallback onTap;

  const CollectionListGenerateView({
    super.key,
    required this.collections,
    required this.length,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return Center(child: const Text('No cuentas con recolecciones.'));
    }
    return Column(
      children: List.generate(length, (index) {
        final collection = collections.elementAt(index);

        // address data
        final String? street = collection.address.elementAt(0);
        final String number =
            '${collection.address.elementAt(1)} ${collection.address.elementAt(2)}'
                .trim();
        final String? neighborhood = collection.address.elementAt(3);

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
                    color: Colors.white60,
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
                                '$street $number, $neighborhood',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
