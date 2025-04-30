import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:flutter/material.dart';

// typedef Callback = void Function(Collection collections);
class CollectionListView extends StatelessWidget {
  final Iterable<Collection> collections;
  final int itemCount;

  const CollectionListView({
    super.key,
    required this.collections,
    required this.itemCount,
  });
  // final Callback onDeleteCollections;
  // final Callback onTap;
  String getAddress() {
    return 'Calle 123, Colonia Centro, 12345';
  }

  String getStatus() {
    return 'En espera';
  }

  @override
  Widget build(BuildContext context) {
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
                title: Row(
                  children: [
                    Text(
                      'Recolección a domicilio',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    const Icon(Icons.circle, color: Colors.amber),
                  ],
                ),
                subtitle: Row(
                  spacing: 15,
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
                            '${getAddress()}',
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
                      '${getStatus()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
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
  }
}
