import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<LatLng>> getRouteWithCallable({
  required LatLng origin,
  required LatLng destination,
}) async {
  final callable = FirebaseFunctions.instance.httpsCallable('getRoute');

  try {
    log('Getting polyline route');
    final response = await callable.call({
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
    });
    final data = response.data;
    final polyline = data['routes'][0]['overview_polyline']['points'];

    final decodedPoints = PolylinePoints().decodePolyline(polyline);
    return decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  } on FirebaseFunctionsException catch (e) {
    log(e.code);
    log(e.message!);
    rethrow;
  }
}
