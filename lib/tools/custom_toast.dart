import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/SystemColors.dart';

class CustomToast extends StatefulWidget {
  const CustomToast({Key? key}) : super(key: key);

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  double _transform = -10;
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        if (_transform == -10) _transform = 80;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      transform: Matrix4.translationValues(0, _transform, 0),
      curve: Curves.fastLinearToSlowEaseIn,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "No Notifications",
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  _transform = _transform == 80 ? -10 : 80;
                });
              },
              icon: Icon(
                Icons.close_rounded,
                size: 20,
              ))
        ],
      ),
    );
  }
}
