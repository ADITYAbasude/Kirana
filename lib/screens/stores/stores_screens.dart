import 'package:flutter/material.dart';

class StoresScreen extends StatefulWidget {
  StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Store screen",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
