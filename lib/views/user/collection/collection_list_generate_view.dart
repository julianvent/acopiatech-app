import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:flutter/material.dart';

class CollectionListGenerateView extends StatelessWidget {
  final Iterable<Collection> collections;
  final int length;

  const CollectionListGenerateView({
    super.key,
    required this.collections,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return const Text('No cuentas con recolecciones.');
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
                          const Icon(Icons.circle, color: Colors.amber),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.date_range),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(date),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 30,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text(
                                    'Entregar en:',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '$street $number, $neighborhood',
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              collection.status,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
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
