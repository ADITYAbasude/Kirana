import 'package:Kirana/constants/SystemColors.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double strokeWidth;
  Loading({this.strokeWidth = 4.0});
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: mainColor,
      strokeWidth: strokeWidth,
    );
  }
}
