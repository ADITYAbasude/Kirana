import 'dart:ffi';

import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

const double iconSize = 30;
int itemIndex = 0;

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: ((value) {
          setState(() {
            itemIndex = value;
          });
        }),
        currentIndex: itemIndex,

        // ignore: prefer_const_literals_to_create_immutables
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: iconSize,
              ),
              label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.location_on_rounded,
                size: iconSize,
              ),
              label: "Location"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.storefront_outlined,
                size: iconSize,
              ),
              label: "Seller"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: iconSize,
              ),
              label: "Profile")
        ]);
  }
}
