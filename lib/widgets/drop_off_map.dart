import 'package:acopiatech/constants/map_style.dart';
import 'package:acopiatech/services/maps/geolocator_service.dart';
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
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _geolocatorService.getCurrentLocationUpdates(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final location = snapshot.data!;
              return GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: location,
                  zoom: 13.66,
                ),
                onMapCreated: (controller) => _onMapCreated(controller),
                style: noPoiMapStyle,
                markers: {
                  Marker(
                    markerId: MarkerId('yo'),
                    position: location,
                    infoWindow: InfoWindow(
                      title: "Tu ubicación",
                      snippet: "Yo merengues",
                    ),
                  ),
                },
              );
            } else {
              return const Center(child: Text(''));
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
