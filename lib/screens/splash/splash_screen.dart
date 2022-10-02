import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery_app/screens/auth/login_signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginSignUpScreen()))
            });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(image: AssetImage('assets/icons/store.png'), width: 100),
        Container(
            padding: EdgeInsets.only(top: 5), child: Text("#AabAapKiApniDukan"))
      ])),
    );
  }
}
