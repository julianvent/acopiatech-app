import 'dart:developer' show log;

import 'package:acopiatech/constants/map_style.dart';
import 'package:acopiatech/services/maps/geocoding_service.dart';
import 'package:acopiatech/services/maps/geolocator_service.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DropOffMap extends StatefulWidget {
  const DropOffMap({super.key});

  @override
  State<DropOffMap> createState() => _DropOffMapState();
}

class _DropOffMapState extends State<DropOffMap> {
  late final GeolocatorService _geolocatorService;
  late GoogleMapController _googleMapController;

  @override
  void initState() {
    _geolocatorService = GeolocatorService();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDropOffs(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final dropoffMarkers = snapshot.data as Set<Marker>;
              return FutureBuilder(
                future: _geolocatorService.getCurrentLocation(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        final location = snapshot.data!;
                        dropoffMarkers.add(
                          Marker(
                            markerId: MarkerId('currentLocation'),
                            position: location,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                          ),
                        );
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: location,
                            zoom: 13.5,
                          ),
                          onMapCreated:
                              (controller) => _onMapCreated(controller),
                          style: noPoiMapStyle,
                          markers: dropoffMarkers,
                        );
                      } else {
                        return const Text('No se pudo cargar el mapa...');
                      }
                    default:
                      return const CustomProgressIndicator(
                        loadingText: 'Cargando mapa...',
                        spacing: 20,
                      );
                  }
                },
              );
            } else {
              return const CustomProgressIndicator(
                loadingText: 'Cargando mapa...',
                spacing: 20,
              );
            }
          default:
            return const CustomProgressIndicator(
              loadingText: 'Cargando mapa...',
              spacing: 20,
            );
        }
      },
    );
  }
}
