// ignore_for_file: deprecated_member_use

/* 
This file is created by Aditya
copyright year 2022
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/auth/login_signup_screen.dart';
import 'package:Kirana/screens/main_screen.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';
import 'package:pinput/pinput.dart';

import '../../tools/loading.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

bool _showProgressBar = false;

class _OTPScreenState extends State<OTPScreen> {
  // late CollectionReference ref;
  FirebaseAuth auth = FirebaseAuth.instance;

  String? _smsCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 2,
          centerTitle: true,
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              )),
          title: const Text("OTP verification",
              style: TextStyle(color: Colors.white)),
        ),
        body: Stack(children: [
          ScrollConfiguration(
            behavior: const ScrollBehavior(
                androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Image.asset("assets/images/otpAnim.gif"),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: const Text(
                  "Verify your phone number with OTP",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 40, right: 40),
                alignment: Alignment.center,
                child: Pinput(
                  onChanged: (value) {
                    setState(() {
                      _smsCode = value.toString();
                    });
                  },
                  length: 6,
                  animationDuration: const Duration(microseconds: 500),
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                ),
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 50, left: 50, right: 50),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        _verifyPhoneNumber();
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ))),
            ])),
          ),
          Center(
              child: Visibility(
                  visible: _showProgressBar,
                  child: Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Loading(),
                      ))))
        ]));
  }

/*
 This function is checking that user typed OTP is should be matched to the server given OTP or
not, if not then it will stop the login process else it will continue the login process/execution
*/
  Future<void> _verifyPhoneNumber() async {
    _showProgressBar = true;
    Map<String, dynamic> userDate = {
      'name': LoginSignUpScreen.username,
      'phone_number': LoginSignUpScreen.phoneNumber
    };

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginSignUpScreen.verificationCode,
        smsCode: _smsCode.toString());

    await auth.signInWithCredential(credential).then((value) {
      String uid = value.user!.uid;
      FirebaseDatabase.instance
          .ref('users')
          .child(uid)
          .child('info')
          .set(userDate)
          .whenComplete(() {
        _showProgressBar = false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SplashScreen()));
      });
    }).onError((error, stackTrace) {
      _showProgressBar = false;
    });
  }
}
