import 'dart:async';
import 'dart:ffi';

import 'package:Kirana/constants/ConstantValue.dart';
import 'package:Kirana/tools/custom_toast.dart';
import "package:flutter/material.dart";
import 'package:Kirana/constants/SystemColors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isVisible = true;
  double _transform = 80;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text(
          "Notifications",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: getScreenSize(context).height,
        width: getScreenSize(context).width,
        child: Stack(children: [
          // Center(
          //     child: ElevatedButton(
          //         onPressed: () {
          //           setState(() {
          //             _isVisible = !_isVisible;
          //           });
          //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //             content: CustomToast(),
          //             behavior: SnackBarBehavior.floating,
          //           ));
          //         },
          //         child: Text('click'))),
        ]),
      ),
    );
  }
}
