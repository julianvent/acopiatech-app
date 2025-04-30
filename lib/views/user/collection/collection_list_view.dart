import 'package:acopiatech/constants/colors_palette.dart';
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
    if (collections.isEmpty) {
      return const Text('No existen recolecciones');
    }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        final collection = collections.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            margin: EdgeInsets.all(10),
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 1,
                  left: 1,
                  right: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          ColorsPalette.backgroundHardGreen,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text('Recolección a domicilio'),
                    subtitle: Text(
                      'Entregar en:\n${getAddress()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getStatus(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.circle, color: Colors.amber),
                          ],
                        ),
                        Icon(Icons.more_vert, color: ColorsPalette.neutralGray),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
