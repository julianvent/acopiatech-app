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
