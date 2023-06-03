import 'package:flutter/material.dart';

import '../../constants/SystemColors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

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
            "Help center",
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'If your need any help, then go to the google and search it there. 🙏',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
