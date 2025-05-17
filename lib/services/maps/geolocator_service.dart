import 'dart:developer';

import 'package:acopiatech/utilities/permission/permissions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocatorService {
  Future<LatLng> getCurrentLocation() async {
    final isLocationGranted = await requestLocationPermission();

    if (isLocationGranted) {
      final currentPosition = await Geolocator.getCurrentPosition();
      log(
        'Current location: ${currentPosition.latitude}, ${currentPosition.longitude}',
        name: 'GeolocatorService',
      );
      return LatLng(currentPosition.latitude, currentPosition.longitude);
    }
    return const LatLng(18.144228260252365, -94.4760033948996);
  }

  Stream<LatLng> getCurrentLocationUpdates() async* {
    final isLocationGranted = await requestLocationPermission();

    if (!isLocationGranted) {
      log("Permissions denied, returning empty stream...");
      yield* const Stream.empty();
      return;
    }

    log("Getting current location...");
    yield* Geolocator.getPositionStream().map((position) {
      log(
        '${position.latitude}, ${position.longitude}',
        name: "GeolocatorService",
      );
      return LatLng(position.latitude, position.longitude);
    });
  }
}
