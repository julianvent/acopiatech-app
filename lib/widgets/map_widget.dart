import 'package:acopiatech/services/maps/geocoding_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final String address;
  const MapWidget({super.key, required this.address});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCoordsFromAddress(address: widget.address),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.done:
            if (asyncSnapshot.hasData) {
              final coords = asyncSnapshot.data as LatLng;
              return GoogleMap(
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
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
