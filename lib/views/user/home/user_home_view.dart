import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:acopiatech/views/user/collection/create_collection_view.dart';
import 'package:acopiatech/widgets/user/user_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  late final userlastCollection = null;
  late final userCollectionOnGoing = [];

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
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  if (snapshot.hasData) {
                                    final collections =
                                        snapshot.data as Iterable<Collection>;
                                    return CollectionListGenerateView(
                                      collections: collections,
                                      length: 1,
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
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsPalette.backgroundDarkGreen,
                      padding: EdgeInsets.all(12.0),
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
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  if (snapshot.hasData) {
                                    final allOngoingCollections =
                                        snapshot.data as Iterable<Collection>;
                                    return CollectionListGenerateView(
                                      collections: allOngoingCollections,
                                      length: 1,
                                    );
                                  } else {
                                    return const Text(
                                      'No cuentas con recolecciones en camino',
                                    );
                                  }
                                default:
                                  return const CircularProgressIndicator();
                              }
                            },
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Center(
                          child: Row(
                            spacing: 10,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorsPalette.backgroundDarkGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  final controller =
                                      Get.find<UserNavigationController>();
                                  controller.setView(1);
                                },
                                child: Text(
                                  'Ver recoleciones',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorsPalette.backgroundDarkGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => BlocProvider(
                                            create:
                                                (_) => AddressBloc(
                                                  AddressStorage(),
                                                )..add(
                                                  const AddressEventLoadAdresses(),
                                                ),
                                            child: const CreateCollectionView(),
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Solicitar recoleción',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorsPalette.backgroundDarkGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    final controller =
                                        Get.find<UserNavigationController>();
                                    controller.setView(1);
                                  },
                                  child: Text(
                                    'Ver recoleciones',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorsPalette.backgroundDarkGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => BlocProvider.value(
                                              value: BlocProvider.of<
                                                CollectionBloc
                                              >(context),
                                              child:
                                                  const CreateCollectionView(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Solicitar recoleción',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              // Map
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Encuentra un centro de acopio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 250,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Google Maps',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
