import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPhotosPermission() async {
  PermissionStatus status = await Permission.photos.status;

  if (!status.isGranted) {
    status = await Permission.photos.request();
  }

  if (status.isGranted) {
    return true;
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
    return false;
  } else {
    return false;
  }
}

Future<bool> requestLocationPermission() async {
  LocationPermission status = await Geolocator.checkPermission();
  log(status.name);

  if (status == LocationPermission.denied) {
    log("Requesting location...");
    status = await Geolocator.requestPermission();
    log("Requesting location again...");
    if (status == LocationPermission.deniedForever) {
      log(status.name);
      return false;
    }
    log(status.name);
    return true;
  }
  log(status.name);
  return true;
}
