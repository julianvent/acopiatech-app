import 'dart:async';
import 'dart:developer';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/map_style.dart';
import 'package:acopiatech/services/maps/geocoding_service.dart';
import 'package:acopiatech/services/maps/geolocator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPolylines extends StatefulWidget {
  final String address;
  const MapPolylines({super.key, required this.address});

  @override
  State<MapPolylines> createState() => _MapPolylinesState();
}

class _MapPolylinesState extends State<MapPolylines> {
  GoogleMapController? _controller;
  late final GeolocatorService _geolocatorService;
  late final Map<PolylineId, Polyline> _polylines;
  LatLng? _currentLocation;
  LatLng? _addressLocation;
  StreamSubscription<LatLng>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _geolocatorService = GeolocatorService();
    _polylines = {};

    getCoordsFromAddress(address: widget.address).then((location) {
      setState(() => _addressLocation = location);
    });

    _locationSubscription = _geolocatorService
        .getCurrentLocationUpdates()
        .listen((location) async {
          if (_currentLocation != null && _addressLocation != null) {
              await _addPolyline(
                destiny: _addressLocation!,
                currentLocation: location,
              );
          }
          setState(() => _currentLocation = location);

          if (_controller != null) {
            _controller!.animateCamera(CameraUpdate.newLatLng(location));
          }
        });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _addPolyline({
    required LatLng destiny,
    required LatLng currentLocation,
  }) async {
    final polylinePoints = PolylinePoints();

    log('Getting polylines...', name: 'MapsPolyline');
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyBRLwkuUv8M9KDUteiIXwXcDPR26EDWnis',
      request: PolylineRequest(
        origin: PointLatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ),
        destination: PointLatLng(destiny.latitude, destiny.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      log('Polylines not empty', name: 'MapsPolyline');
      final List<LatLng> polylineCoordinates =
          result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

      final PolylineId polylineId = PolylineId('polyline_id');

      final Polyline polyline = Polyline(
        polylineId: polylineId,
        color: ColorsPalette.backgroundHardGreen,
        points: polylineCoordinates,
        width: 5,
      );

      setState(() {
        _polylines[polylineId] = polyline;
      });
    }
    log('Finished calculating polylines', name: 'MapsPolyline');
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null || _addressLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _currentLocation!,
        zoom: 13.5,
      ),
      onMapCreated: (controller) async {
        _controller = controller;
      },
      style: noPoiMapStyle,
      markers: {
        Marker(markerId: MarkerId('Recoleccion'), position: _addressLocation!),
      },
      polylines: Set<Polyline>.of(_polylines.values),
    );
  }
}
