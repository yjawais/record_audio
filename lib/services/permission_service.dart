import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    print(status);
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }
}