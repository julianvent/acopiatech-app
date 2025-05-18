import 'dart:async';
import 'dart:developer';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/map_style.dart';
import 'package:acopiatech/services/maps/geocoding_service.dart';
import 'package:acopiatech/services/maps/geolocator_service.dart';
import 'package:acopiatech/services/maps/maps_functions.dart';
import 'package:acopiatech/widgets/custom_progress_indicator.dart';
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
    _controller!.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _addPolyline({
    required LatLng destiny,
    required LatLng currentLocation,
  }) async {
    log('Getting polylines...', name: 'MapsPolyline');
    final polylineCoordinates = await getRouteWithCallable(
      origin: currentLocation,
      destination: destiny,
    );

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

    log('Finished calculating polylines', name: 'MapsPolyline');
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null || _addressLocation == null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: const CustomProgressIndicator(
          loadingText: 'Cargando mapa...',
          spacing: 20,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 450,
          child: GoogleMap(
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
              Marker(
                markerId: MarkerId('Recoleccion'),
                position: _addressLocation!,
              ),
            },
            polylines: Set<Polyline>.of(_polylines.values),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'Se calcurá la ruta más óptima. Las actualizaciones dependerán de la calidad de la conexión a internet actual.',
            style: TextStyle(fontSize: 13, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
