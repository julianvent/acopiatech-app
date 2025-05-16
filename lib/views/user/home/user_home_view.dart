import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:acopiatech/views/user/collection/create_collection_view.dart';
import 'package:acopiatech/views/user/collection/collection_details_view.dart';
import 'package:acopiatech/views/user/home/user_dropoff_list_view.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            spacing: 50,
            children: [
              // last collection
              Column(
                spacing: 20,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Última solicitud de recolección',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
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
                                      onTap: (collection) => onTap(collection),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsPalette.backgroundDarkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
                    child: const Text(
                      'Solicitar recolección',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // ongoing collections
              Column(
                spacing: 20,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recolecciones en camino',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
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
                                      onTap: (collection) => onTap(collection),
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
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsPalette.backgroundDarkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        final controller = Get.find<UserNavigationController>();
                        controller.setView(1);
                      },
                      child: Text(
                        'Ver recoleciones',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Map
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Encuentra un centro de acopio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 300, child: DropOffMap()),
                  SizedBox(
                    child: Column(
                      spacing: 20,
                      children: [
                        DropOffView(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserDropoffListView(),
                              ),
                            );
                          },
                          child: Text('Ver centros de acopio'),
                        ),
                      ],
                    ),
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
