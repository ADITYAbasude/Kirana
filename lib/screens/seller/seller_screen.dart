// ignore_for_file: deprecated_member_use, use_build_context_synchronously

/* 
This file is created by Aditya
copyright year 2022
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/seller/add_seller_detail_screen.dart';
import 'package:grocery_app/screens/seller/seller_home_screen.dart';
import 'package:grocery_app/tools/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerScreen extends StatefulWidget {
  SellerScreen({Key? key}) : super(key: key);

  static String exist = "";
  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

var _uid = FirebaseAuth.instance.currentUser!.uid;

DatabaseReference _dbRef = FirebaseDatabase.instance.ref("sellers");

class _SellerScreenState extends State<SellerScreen> {
  @override
  void initState() {
    super.initState();
    _checkSellerIsExistOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(top: 80),
                        child: Image.asset("assets/images/revenue.jpg"),
                      ),
                      Container(
                        // margin: EdgeInsets.only(top: 30),
                        child: const Text(
                          "Launch your business in just a minute",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 20),
                    child: OutlinedButton(
                        onPressed: () async {
                          _checkSellerIsExistOrNot();
                          final prefs = await SharedPreferences.getInstance();
                          SellerScreen.exist =
                              prefs.getString('seller').toString();

                          if (SellerScreen.exist == "seller") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        SellerHomeScreen())));
                          } else {
                            Navigator.of(context).push(RouteTranslation());
                          }
                        },
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor)),
                        child: const Text("Continue as a seller")),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Route RouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddSellerDetailScreen(),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.fastOutSlowIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }));
  }

  _checkSellerIsExistOrNot() async {
    showToast("working");
    _dbRef.get().then((value) {
      if (value.hasChild(_uid)) {
        SellerScreen.exist = "seller";
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => const SellerHomeScreen())));
      }
    });
  }
}
