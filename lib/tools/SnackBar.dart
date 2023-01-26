// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String msg,
    {Color color = const Color.fromARGB(255, 34, 33, 33),
    Duration d = const Duration(seconds: 2)}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    duration: d,
  ));
}
