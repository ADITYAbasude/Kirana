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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text(
          "My Favorites",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
    );
  }
}
