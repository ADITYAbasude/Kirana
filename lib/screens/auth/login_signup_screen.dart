import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/screens/auth/otp_screen.dart';
import 'package:grocery_app/tools/Toast.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);
  static String verificationCode = "";

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

bool _showProgressBar = false;

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Stack(children: [
          ScrollConfiguration(
              behavior: const ScrollBehavior(
                  // ignore: deprecated_member_use
                  androidOverscrollIndicator:
                      AndroidOverscrollIndicator.stretch),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: const Image(
                          image: AssetImage("assets/images/attraction.jpg"))),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        // ignore: prefer_const_constructors
                        Padding(
                            padding: const EdgeInsets.all(10),
                            // ignore: prefer_const_constructors
                            child: Text(
                              "Login or SignUp your account",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            )),
                        // ignore: prefer_const_constructors
                        Container(
                          width: double.infinity,
                          child: Expanded(
                              child: Divider(
                            color: Colors.white,
                          )),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 70,
                            // ignore: prefer_const_constructors
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              maxLength: 10,
                              maxLines: 1,
                              controller: phoneNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                // errorMaxLines: 10,
                                hintText: "Phone number",
                                hintStyle: const TextStyle(
                                    fontSize: 14, color: Colors.white),

                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      '+91',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            )),

                        Container(
                            margin: const EdgeInsets.only(top: 25),
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                onPressed: () async {
                                  _sendOTP();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text(
                                  "Send OTP",
                                  style: TextStyle(color: Colors.black),
                                )))
                      ],
                    ),
                  )
                ],
              ))),
          Visibility(
              visible: _showProgressBar,
              child: Positioned(
                  top: MediaQuery.of(context).size.height / 2,
                  left: MediaQuery.of(context).size.width / 2.5,
                  child: const CircularProgressIndicator(
                    color: Colors.green,
                  )))
        ]));
  }

  Future<void> _sendOTP() async {
    String phoneNumber = "+91${phoneNumberController.text}";
    // MakeToast().showToast(phoneNumber);
    setState(() {
      _showProgressBar = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          setState(() {
            _showProgressBar = false;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _showProgressBar = false;
          });
          MakeToast().showToast(e.message.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _showProgressBar = false;
          });
          LoginSignUpScreen.verificationCode = verificationId;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OTPScreen()));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}
