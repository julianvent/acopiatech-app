import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/user/collection/collection_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// typedef Callback = void Function(Collection collections);
class CollectionListView extends StatelessWidget {
  final Collection? collection;

  const CollectionListView({super.key, required this.collection});
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
    if (collection == null) {
      return const Text('No cuentas con direcciones registradas.');
    }

    final String? street = collection?.address.elementAt(0);
    final String number =
        '${collection?.address.elementAt(1)} ${collection?.address.elementAt(2)}'
            .trim();
    final String? neighborhood = collection?.address.elementAt(3);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: BlocProvider.of<CollectionBloc>(context),
                  child: CollectionDetailsView(collection: collection!),
                ),
          ),
        );
      },
      child: Card(
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
                          collection!.timeCreated.toIso8601String(),
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
                  ),
                  subtitle: Row(
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
                              '$street #$number $neighborhood',
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
                        collection!.status.status,
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
      ),
    );
  }
}
