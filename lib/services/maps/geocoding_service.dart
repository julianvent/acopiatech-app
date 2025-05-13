import 'dart:developer' show log;

import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> getCoordsFromAddress({required String address}) async {
  try {
    List<Location> locations = await locationFromAddress(address);

    if (locations.isNotEmpty) {
      final location = locations.first;
      return LatLng(location.latitude, location.longitude);
    } else {
      log("Could not get location from address");
      return const LatLng(18.14431461778299, -94.47604801699983);
    }
  } on Exception {
    rethrow;
  }
}

Stream<Set<Marker>> getDropOffs() async* {
  final AddressStorage addressService = AddressStorage();
  log('Getting dropoffs');
  final Set<Marker> dropoffMarkers = {};

  await for (final dropoffs in addressService.allDropOffs()) {
    log('Dropoff list: ${dropoffs.isEmpty.toString()}');

    final markerFuture =
        dropoffs.map((dropoff) async {
          final addressLocation = await getCoordsFromAddress(
            address: dropoff.toString(),
          );
          log('Dropoff coords: ${addressLocation.toString()}');

          return Marker(
            markerId: MarkerId(dropoff.toString()),
            position: addressLocation,
            infoWindow: InfoWindow(title: dropoff.toString()),
          );
        }).toList();

    final markers = await Future.wait(markerFuture);
    yield markers.toSet();
  }
}
