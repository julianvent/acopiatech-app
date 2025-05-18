import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/auth/auth_user.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/views/user/collection/collection_details_view.dart';
import 'package:acopiatech/views/user/collection/collection_list_generate_view.dart';
import 'package:acopiatech/widgets/custom_app_bar.dart';
import 'package:acopiatech/widgets/custom_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBonusView extends StatefulWidget {
  final AuthUser currentUser;
  const UserBonusView({super.key, required this.currentUser});

  @override
  State<UserBonusView> createState() => _UserBonusViewState();
}

class _UserBonusViewState extends State<UserBonusView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUser;
    context.read<CollectionBloc>().add(
      CollectionEventLoadAllCompletedCollection(ownerUserId: currentUser.id),
    );
    return Scaffold(
      appBar: CustomAppBar(title: 'Recompensas').navigatorAppBar,
      body: Column(
        spacing: 20,
        children: [
          SizedBox(
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

                            int totalPoints = collections.fold(0, (
                              sum,
                              collection,
                            ) {
                              return sum + (collection.pointsEarned ?? 0);
                            });
                            if (collections.isNotEmpty) {
                              return Column(
                                spacing: 20,
                                children: [
                                  CustomDetail(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Puntos acumulados',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: 'Tienes un total de ',
                                          style: TextStyle(fontSize: 20),
                                          children: [
                                            TextSpan(
                                              text: '$totalPoints',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' puntos',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: CollectionListGenerateView(
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
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Center(
                                child: CustomDetail(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 20,
                                  children: [
                                    Text(
                                      'No cuentas con recolecciones con puntos.\n'
                                      '¡Crea una recolección!',
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
    );
  }
}
