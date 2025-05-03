import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:acopiatech/views/admin/collection/admin_collection_details_view.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  void onTap(Collection collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: BlocProvider.of<CollectionBloc>(context),
              child: AdminCollectionDetailsView(collection: collection),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<CollectionBloc>().add(const CollectionEventLoadCollections());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            spacing: 20,
            children: [
              // Sigue una recolección
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                child: Column(
                  spacing: 30,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sigue una recolección',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Center(
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
                                          statusFilter:
                                              CollectionStatus.enCamino,
                                          length: collections.length,
                                          onTap:
                                              (collection) => onTap(collection),
                                        );
                                      } else {
                                        return const Text(
                                          'No existen recolecciones activas.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
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
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                child: Column(
                  spacing: 30,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recolecciones del día',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Center(
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
                                          dayFilter: DateTime.now().day,
                                          length: collections.length,
                                          onTap:
                                              (collection) => onTap(collection),
                                        );
                                      } else {
                                        return const Text(
                                          'No hay recolecciones programadas.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
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
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsPalette.backgroundDarkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Ver recolecciones',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
