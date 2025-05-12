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
    status = await Geolocator.requestPermission();
    log("Location denied");
    if (status == LocationPermission.denied) {
      return false;
    }
    return true;
  } else if (status == LocationPermission.deniedForever) {
    log("Location denied forever");
    openAppSettings();
    return false;
  }

  return true;
}
