// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/auth/login_signup_screen.dart';
import 'package:grocery_app/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? auth = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => {
              // ignore: unnecessary_null_comparison
              // if (auth != null)
              //   {
              //     Navigator.pushReplacement(context,
              //         MaterialPageRoute(builder: (context) => MainScreen()))
              //   }
              // else
              //   {
              //     Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => LoginSignUpScreen()))
              //   }

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainScreen()))
            });
  }

  @override
  // ignore: duplicate_ignore
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructor
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
