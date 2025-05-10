import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> getCoordsFromAddress({required String address}) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      } else {
        return const LatLng(18.14431461778299, -94.47604801699983);
      }
    } on Exception {
      rethrow;
    }
  }