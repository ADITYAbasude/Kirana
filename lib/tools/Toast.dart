import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MakeToast {
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        textColor: Color.fromARGB(255, 0, 0, 0),
        fontSize: 16.0);
  }
}