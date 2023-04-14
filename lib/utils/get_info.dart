import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

var uid = FirebaseAuth.instance.currentUser!.uid;

class UserData {
  static Future<dynamic> userName(String uid) async {
    var a = await FirebaseDatabase.instance
        .ref('users')
        .child(uid)
        .child('info')
        .once();

    var data = a.snapshot.value as Map;

    return data['name'];
  }

  static Future<dynamic> userData(String uid) async {
    var a = await FirebaseDatabase.instance
        .ref('users')
        .child(uid)
        .child('info')
        .once();

    var data = a.snapshot.value as Map;

    return data;
  }

  static Future<dynamic> getSellerName(String sellerId) async {
    var sellerName = "";
    await FirebaseDatabase.instance
        .ref('sellers/${sellerId}/info')
        .get()
        .then((value) {
      var data = value.value as Map;
      sellerName = data['shop_name'];
    });

    return sellerName;
  }

  static Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
