import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:acopiatech/views/user/collection/create_collection_view.dart';
import 'package:acopiatech/views/user/collection/collection_details_view.dart';
import 'package:acopiatech/views/user/home/user_dropoff_list_view.dart';
import 'package:acopiatech/widgets/custom_button.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
import 'package:acopiatech/widgets/custom_section.dart';
import 'package:acopiatech/widgets/drop_off_map.dart';
import 'package:acopiatech/widgets/dropoff_view.dart';
import 'package:acopiatech/widgets/user/user_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  late GoogleMapController mapsController;

  final LatLng _center = const LatLng(18.14431461778299, -94.47604801699983);

  void onMapCreated(GoogleMapController controller) {
    mapsController = controller;
  }

  void onTap(Collection collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: BlocProvider.of<CollectionBloc>(context),
              child: CollectionDetailsView(collection: collection),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<CollectionBloc>().add(const CollectionEventLoadCollections());

    return Scaffold(
      backgroundColor: ColorsPalette.black1,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 30,
            children: [
              Column(
                spacing: 10,
                children: [
                  CustomSection(title: 'Última solicitud de recolección'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: BlocBuilder<CollectionBloc, CollectionState>(
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
                                      if (collections.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            'No cuentas con recolecciones\n¡Solicita una ahora!',
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                      return CollectionListGenerateView(
                                        collections: collections,
                                        length: 1,
                                        onTap:
                                            (collection) => onTap(collection),
                                      );
                                    } else {
                                      return const CustomProgressIndicator(
                                        loadingText:
                                            'Cargando última recolección...',
                                        spacing: 20,
                                      );
                                    }
                                  default:
                                    return const CustomProgressIndicator(
                                      loadingText:
                                          'Cargando última recolección...',
                                      spacing: 20,
                                    );
                                }
                              },
                            );
                          } else {
                            return const CustomProgressIndicator(
                              loadingText: 'Cargando última recolección...',
                              spacing: 20,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  CustomButton(
                    title: 'Solicitar recolección',
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value: BlocProvider.of<CollectionBloc>(
                                    context,
                                  ),
                                  child: CreateCollectionView(),
                                ),
                          ),
                        ),
                  ),
                ],
              ),
              // ongoing collections
              Column(
                spacing: 10,
                children: [
                  CustomSection(title: 'Recolecciones en camino'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: BlocBuilder<CollectionBloc, CollectionState>(
                        builder: (context, state) {
                          if (state is CollectionStateLoadedCollections) {
                            return StreamBuilder(
                              stream: state.ongoingCollectionsStream,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.active:
                                    if (snapshot.hasData) {
                                      final allOngoingCollections =
                                          snapshot.data as Iterable<Collection>;
                                      if (allOngoingCollections.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            'Esté al tanto de sus recolecciones en camino.',
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                      return CollectionListGenerateView(
                                        collections: allOngoingCollections,
                                        length: 1,
                                        onTap:
                                            (collection) => onTap(collection),
                                      );
                                    } else {
                                      return const CustomProgressIndicator(
                                        loadingText:
                                            'Cargando recolecciones en camino...',
                                        spacing: 20,
                                      );
                                    }
                                  default:
                                    return const CustomProgressIndicator(
                                      loadingText:
                                          'Cargando recolecciones en camino...',
                                      spacing: 20,
                                    );
                                }
                              },
                            );
                          }
                          return const CustomProgressIndicator(
                            loadingText: 'Cargando recolecciones en camino...',
                            spacing: 20,
                          );
                        },
                      ),
                    ),
                  ),
                  CustomButton(
                    title: 'Ver recolecciones',
                    onPressed: () {
                      final controller = Get.find<UserNavigationController>();
                      controller.setView(1);
                    },
                  ),
                ],
              ),
              // Map
              Column(
                spacing: 15,
                children: [
                  Column(
                    children: [
                      CustomSection(title: 'Encuentra un centro de acopio'),
                      SizedBox(height: 400, child: DropOffMap()),
                    ],
                  ),
                  Column(
                    spacing: 20,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropOffView(),
                      ),
                      CustomButton(
                        title: 'Ver centros de acopio',
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserDropoffListView(),
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              // Centros de acopio
            ],
          ),
        ),
      ),
    );
  }
}
