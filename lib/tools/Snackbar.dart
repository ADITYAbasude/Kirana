import 'package:flutter/material.dart';

class MakeSnackBar {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static void showSnackBar(String msg) {
    if (msg == null) return null;

    final snackBar = SnackBar(content: Text(msg));

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
