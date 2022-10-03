import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                    child: Image(
                        image: AssetImage("assets/images/attraction.jpg"))),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.all(10),
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
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                      // ignore: prefer_const_constructors

                      Container(
                          // ignore: prefer_const_constructors
                          height: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Phone number",
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
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
                          margin: EdgeInsets.only(top: 25),
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () => {},
                              child: Text(
                                "Send OTP",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  backgroundColor:
                                      Theme.of(context).primaryColor)))
                    ],
                  ),
                )
              ],
            ))));
  }
}
