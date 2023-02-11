import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
