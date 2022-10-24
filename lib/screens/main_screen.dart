import 'package:flutter/material.dart';
import 'package:grocery_app/screens/orders/orders_screen.dart';
import 'package:grocery_app/screens/profile/profile_screen.dart';
import 'package:grocery_app/screens/seller/seller_screen.dart';
import 'package:grocery_app/screens/stores/stores_screens.dart';
import 'package:grocery_app/tools/Toast.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  static int itemIndex = 0;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

const double iconSize = 25;

class _MainScreenState extends State<MainScreen> {
  final screens = [
    StoresScreen(),
    OrderScreen(),
    SellerScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   elevation: 2,
      // ),
      body: screens[MainScreen.itemIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: ((value) {
            setState(() {
              MainScreen.itemIndex = value;
            });
          }),
          currentIndex: MainScreen.itemIndex,
          // selectedIconTheme:  selectedIcons[selectedIcons],
          // ignore: prefer_const_literals_to_create_immutables
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                  size: iconSize,
                ),
                label: "Home"),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_bag_rounded,
                  size: iconSize,
                ),
                label: "Orders"),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.storefront_rounded,
                  size: iconSize,
                ),
                label: "Seller"),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                  size: iconSize,
                ),
                label: "Profile")
          ]),
    );
  }
}
