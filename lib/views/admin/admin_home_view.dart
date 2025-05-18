import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:acopiatech/views/admin/collection/admin_collection_details_view.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:acopiatech/widgets/admin/admin_navigation_controller.dart';
import 'package:acopiatech/widgets/custom_button.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
import 'package:acopiatech/widgets/custom_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
        child: Column(
          spacing: 30,
          children: [
            // Sigue una recolección
            Column(
              spacing: 10,
              children: [
                const CustomSection(title: 'Sigue una recolección'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      noCollectionText:
                                          'No existen recolecciones activas.',
                                      collections: collections,
                                      statusFilter: CollectionStatus.enCamino,
                                      length: collections.length,
                                      onTap: (collection) => onTap(collection),
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
                                  return const CustomProgressIndicator(
                                    loadingText: 'Cargando recolecciones...',
                                    spacing: 20,
                                  );
                                }
                              default:
                                return const CustomProgressIndicator(
                                  loadingText: 'Cargando recolecciones...',
                                  spacing: 20,
                                );
                            }
                          },
                        );
                      } else {
                        return const CustomProgressIndicator(
                          loadingText: 'Cargando recolecciones...',
                          spacing: 20,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              spacing: 10,
              children: [
                const CustomSection(title: 'Recolecciones del día'),
                BlocBuilder<CollectionBloc, CollectionState>(
                  builder: (context, state) {
                    if (state is CollectionStateLoadedCollections) {
                      return StreamBuilder(
                        stream: state.collectionsStream,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                final collections =
                                    snapshot.data as Iterable<Collection>;
                                if (collections.isNotEmpty) {
                                  return CollectionListGenerateView(
                                    collections: collections,
                                    dayFilter: DateTime.now().day,
                                    length: collections.length,
                                    noCollectionText:
                                        'No existen recolecciones programadas.',
                                    onTap: (collection) => onTap(collection),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                    ),
                                    child: const Text(
                                      'No hay recolecciones programadas.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return const CustomProgressIndicator(
                                  loadingText:
                                      'Cargando recolecciones del día...',
                                  spacing: 20,
                                );
                              }
                            default:
                              return const CustomProgressIndicator(
                                loadingText:
                                    'Cargando recolecciones del día...',
                                spacing: 20,
                              );
                          }
                        },
                      );
                    } else {
                      return const CustomProgressIndicator(
                        loadingText: 'Cargando recolecciones del día...',
                        spacing: 20,
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomButton(
                    title: 'Ver recolecciones',
                    onPressed: () {
                      final controller = Get.find<AdminNavigationController>();
                      controller.setView(1);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
