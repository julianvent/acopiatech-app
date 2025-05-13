import 'dart:developer' show log;

import 'package:acopiatech/constants/map_style.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/services/maps/geocoding_service.dart';
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
  late final AddressStorage _addressStorage;
  late final Set<Marker> _dropoff_markers;

  @override
  void initState() {
    _geolocatorService = GeolocatorService();
    _addressStorage = AddressStorage();
    _dropoff_markers = {};
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getDropOffs(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final dropoffMarkers = snapshot.data as Set<Marker>;
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
                          onMapCreated:
                              (controller) => _onMapCreated(controller),
                          style: noPoiMapStyle,
                          markers: dropoffMarkers,
                        );
                      } else {
                        return const Center(child: Text(''));
                      }
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
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
