import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:grocery_app/screens/auth/otp_screen.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: ScrollConfiguration(
            behavior: const ScrollBehavior(
                // ignore: deprecated_member_use
                androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
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
                          padding: const EdgeInsets.all(20),
                          // ignore: prefer_const_constructors
                          child: Text(
                            "Login or SignUp your account",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          )),
                      // ignore: prefer_const_constructors

                      Container(
                          height: 70,
                          // ignore: prefer_const_constructors
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            maxLength: 10,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // errorMaxLines: 10,
                              hintText: "Phone number",
                              hintStyle: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 10),
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
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OTPScreen()))
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
            ))));
  }
}
