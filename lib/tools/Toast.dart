import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textColor: const Color.fromARGB(255, 0, 0, 0),
        fontSize: 16.0);
  }
