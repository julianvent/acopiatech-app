import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/admin/collection/admin_collection_details_view.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCollectionView extends StatefulWidget {
  const AdminCollectionView({super.key});

  @override
  State<AdminCollectionView> createState() => _AdminCollectionViewState();
}

class _AdminCollectionViewState extends State<AdminCollectionView> {
  late final Collection collections;

  @override
  Widget build(BuildContext context) {
    context.read<CollectionBloc>().add(const CollectionEventLoadCollections());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial de recolecciones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorsPalette.greenShadow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
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
                                if (collections.isNotEmpty) {
                                  return CollectionListGenerateView(
                                    collections: collections,
                                    length: collections.length,
                                    onTap: (collection) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BlocProvider.value(
                                                value: BlocProvider.of<
                                                  CollectionBloc
                                                >(context),
                                                child:
                                                    AdminCollectionDetailsView(
                                                      collection: collection,
                                                    ),
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Column(
                                      spacing: 20,
                                      children: [
                                        Text(
                                          'No hay ninguna recolección programada\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Icon(
                                          Icons.recycling,
                                          size: 100,
                                          color: ColorsPalette.lightGreen,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            default:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                          }
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
