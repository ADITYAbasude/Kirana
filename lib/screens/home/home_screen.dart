import 'package:flutter/material.dart';
import 'package:grocery_app/screens/orders/orders_screen.dart';
import 'package:grocery_app/screens/profile/profile_screen.dart';
import 'package:grocery_app/screens/seller/seller_screen.dart';
import 'package:grocery_app/screens/stores/stores_screens.dart';
import 'package:grocery_app/tools/Toast.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static int itemIndex = 0;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const double iconSize = 25;

class _HomeScreenState extends State<HomeScreen> {
  final screens = [
    StoresScreen(),
    OrderScreen(),
    SellerScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
      ),
      body: screens[HomeScreen.itemIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: ((value) {
            setState(() {
              HomeScreen.itemIndex = value;
            });
          }),
          currentIndex: HomeScreen.itemIndex,
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
