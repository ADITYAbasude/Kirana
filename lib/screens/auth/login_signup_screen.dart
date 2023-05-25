// ignore_for_file: prefer_is_not_empty

/* 
  This file is created by Aditya
copyright year 2022


NOTES: If you have to login then you will refer this mobile number (1234567890) and OTP is (123456).
      This is default login setup for developers
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/auth/otp_screen.dart';
import 'package:Kirana/tools/Toast.dart';
import 'package:Kirana/tools/loading.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);
  static String verificationCode = "";
  static String username = "";
  static String phoneNumber = "";

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

bool _showProgressBar = false;

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final phoneNumberController = TextEditingController();
  final _usernameController = TextEditingController();

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
                      height: MediaQuery.of(context).size.height / 1.7,
                      alignment: Alignment.center,
                      child: const Image(
                          image: AssetImage("assets/images/attraction.jpg"))),
                  // Container(
                  //   child: Text(
                  //     'A whole grocery store at your fingertips',
                  //     style:
                  //         TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 10, top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    width: double.infinity,
                    height: 310,
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
                          child: const Divider(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          child: TextField(
                            minLines: 1,
                            style: TextStyle(color: Colors.white),
                            controller: _usernameController,
                            decoration: InputDecoration(
                              // errorMaxLines: 10,
                              hintText: "Username",
                              hintStyle: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
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
                                        color: Colors.green, width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: const Text(
                                          '+91 ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        )),
                                    Container(
                                      height: 30,
                                      child:
                                          VerticalDivider(color: Colors.white),
                                    )
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
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text(
                                  "Send OTP",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )))
                      ],
                    ),
                  )
                ],
              ))),
          Visibility(
              visible: _showProgressBar,
              child: Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Loading(),
                  )))
        ]));
  }

  Future<void> _sendOTP() async {
    LoginSignUpScreen.phoneNumber = "+91${phoneNumberController.text}";
    String userName = _usernameController.text;

    if (LoginSignUpScreen.phoneNumber.isNotEmpty && userName.isNotEmpty) {
      setState(() {
        _showProgressBar = true;
      });
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: LoginSignUpScreen.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            setState(() {
              _showProgressBar = false;
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _showProgressBar = false;
            });
            showToast(e.message.toString());
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _showProgressBar = false;
            });
            LoginSignUpScreen.username = _usernameController.text;
            LoginSignUpScreen.verificationCode = verificationId;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OTPScreen()));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } else {
      showToast("Enter the username and phone number to continue");
    }
  }
}
