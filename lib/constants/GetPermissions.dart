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
}
