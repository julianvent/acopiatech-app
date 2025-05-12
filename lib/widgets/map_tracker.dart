import 'dart:developer';

import 'package:acopiatech/utilities/permission/permissions.dart';
import 'package:flutter/material.dart';

class MapTracker extends StatefulWidget {
  const MapTracker({super.key});

  @override
  State<MapTracker> createState() => _MapTrackerState();
}

class _MapTrackerState extends State<MapTracker> {
  late bool _requestPermissionStatus;

  Future<bool> getCurrentLocation() async {
    _requestPermissionStatus = await requestLocationPermission();
    return _requestPermissionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentLocation(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.done:
            if (snapshot.hasData) {
              final status = snapshot.data;
              log(status.toString());
              return Center(
                child: Text(status != null && status ? "Adrian" : "Kevin"),
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
