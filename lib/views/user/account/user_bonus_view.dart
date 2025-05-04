import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/user/collection/collection_details_view.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBonusView extends StatefulWidget {
  const UserBonusView({super.key});

  @override
  State<UserBonusView> createState() => _UserBonusViewState();
}

class _UserBonusViewState extends State<UserBonusView> {
  @override
  Widget build(BuildContext context) {
    context.read<CollectionBloc>().add(
      const CollectionEventLoadAllCompletedCollection(),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('User Bonus')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          child: Column(
            spacing: 20,
            children: [
              Text(
                'Puntos acumulados',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
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
                                                child: CollectionDetailsView(
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
                                          'No cuentas con recolecciones con puntos\n'
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
                                    ),
                                  );
                                }
                              } else {
                                return const CircularProgressIndicator();
                              }
                            default:
                              return const CircularProgressIndicator();
                          }
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
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
