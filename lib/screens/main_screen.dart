import 'package:flutter/material.dart';
import 'package:grocery_app/screens/cart/cart_screen.dart';
import 'package:grocery_app/screens/home/search_screen.dart';
import 'package:grocery_app/screens/profile/my_favorites_screen.dart';
import 'package:grocery_app/screens/profile/profile_screen.dart';
import 'package:grocery_app/screens/home/home_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  static int itemIndex = 0;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

const double iconSize = 25;
String exist = "";

class _MainScreenState extends State<MainScreen> {
  final screens = [
    HomeScreen(),
    CartScreen(),
    MyFavoritesScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    _checkSeller();
    return Scaffold(
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
            BottomNavigationBarItem(
                icon: Icon(
                  MainScreen.itemIndex == 0
                      ? Icons.dashboard_rounded
                      : Icons.dashboard_outlined,
                  size: iconSize,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  MainScreen.itemIndex == 1
                      ? Icons.shopping_cart_rounded
                      : Icons.shopping_cart_outlined,
                  size: iconSize,
                ),
                label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(
                  MainScreen.itemIndex == 2
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: iconSize,
                ),
                label: "Favorites"),
            BottomNavigationBarItem(
                icon: Icon(
                  MainScreen.itemIndex == 3
                      ? Icons.account_circle_rounded
                      : Icons.account_circle_outlined,
                  size: iconSize,
                ),
                label: "Profile")
          ]),
    );
  }

  Future _checkSeller() async {
    final prefs = await SharedPreferences.getInstance();
    exist = prefs.getString('seller').toString();
  }
}
