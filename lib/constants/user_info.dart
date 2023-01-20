import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var uid = FirebaseAuth.instance.currentUser!.uid;

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
