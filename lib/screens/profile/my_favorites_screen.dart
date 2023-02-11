import 'package:flutter/material.dart';

import '../../constants/SystemColors.dart';

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({Key? key}) : super(key: key);

  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Favorites",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
    );
  }
}
