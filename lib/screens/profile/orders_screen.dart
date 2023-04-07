import 'package:flutter/material.dart';

import '../../constants/SystemColors.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({Key? key}) : super(key: key);

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
          "Orders",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: const Center(
          child: Text(
            "Order screen",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
