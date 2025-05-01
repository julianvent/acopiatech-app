import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:acopiatech/views/user/collection/create_collection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCollectionView extends StatefulWidget {
  const UserCollectionView({super.key});

  @override
  State<UserCollectionView> createState() => _UserCollectionViewState();
}

class _UserCollectionViewState extends State<UserCollectionView> {
  late final Collection collections;

  @override
  Widget build(BuildContext context) {
    context.read<CollectionBloc>().add(const CollectionEventLoadCollections());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          children: <Widget>[
            SizedBox(
              child: BlocBuilder<CollectionBloc, CollectionState>(
                builder: (context, state) {
                  if (state is CollectionStateLoadedCollections) {
                    return StreamBuilder(
                      stream: state.collectionsStream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final collections =
                                  snapshot.data as Iterable<Collection>;
                              return CollectionListGenerateView(
                                collections: collections,
                                length: collections.length,
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          default:
                            return const CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return Column(
                      spacing: 20,
                      children: [
                        Text(
                          'No cuentas con ninguna recolección\n'
                          '¡Crear una recolección!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.recycling,
                          size: 100,
                          color: ColorsPalette.lightGreen,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: BlocProvider.of<CollectionBloc>(context),
                          child: CreateCollectionView(),
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsPalette.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                fixedSize: Size(200, 50),
              ),
              child: Text(
                'Solicitar recolección',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
