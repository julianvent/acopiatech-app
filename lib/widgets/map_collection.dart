import 'package:acopiatech/services/maps/geocoding_service.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCollection extends StatefulWidget {
  final String address;
  const MapCollection({super.key, required this.address});

  @override
  State<MapCollection> createState() => _MapCollectionState();
}

class _MapCollectionState extends State<MapCollection> {
  late final GoogleMapController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCoordsFromAddress(address: widget.address),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
            if (asyncSnapshot.hasData) {
              final coords = asyncSnapshot.data as LatLng;
              return SizedBox(
                height: 450,
                child: GoogleMap(
                  onMapCreated: (controller) => _controller = controller,
                  initialCameraPosition: CameraPosition(
                    target: coords,
                    zoom: 17.66,
                  ),
                  liteModeEnabled: true,
                  markers: {
                    Marker(
                      markerId: MarkerId('Punto de recolección'),
                      position: coords,
                    ),
                  },
                ),
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
