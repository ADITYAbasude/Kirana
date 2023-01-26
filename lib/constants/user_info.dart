import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
}
