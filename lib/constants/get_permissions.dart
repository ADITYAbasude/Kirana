import 'package:grocery_app/screens/home/home_screens.dart';
import 'package:grocery_app/tools/Toast.dart';
import 'package:permission_handler/permission_handler.dart';

class GetPermissions {
  Future LocationAccessRequest() async {
    Map<Permission, PermissionStatus> statues =
        await [Permission.location].request();
  }

  Future StorageAccessRequest() async {
    Map<Permission, PermissionStatus> statues =
        await [Permission.storage].request();
  }

  Future<void> RequestGpsService() async {
    if (!await location.serviceEnabled()) {
      location.requestService();
    }
  }
}
