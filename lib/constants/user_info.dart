import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static Future<String> userName(String uid) async {
    var a = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('UserData')
        .doc('info')
        .get();
    return a.get('name').toString();
  }
}
