import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:grocery_app/screens/auth/login_signup_screen.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/tools/Toast.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  String? _smsCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
          child: SingleChildScrollView(
              child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              child: Pinput(
                onChanged: (value) {
                  setState(() {
                    _smsCode = value.toString();
                  });
                },
                length: 6,
                animationDuration: Duration(microseconds: 500),
                // androidSmsAutofillMethod:
                //     AndroidSmsAutofillMethod.smsRetrieverApi,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () async {
                      _verifyPhoneNumber();
                      if (auth != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }
                    },
                    child: const Text("Continue")))
          ])),
        ));
  }

  Future<void> _verifyPhoneNumber() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginSignUpScreen.verificationCode,
        smsCode: _smsCode.toString());

    await auth.signInWithCredential(credential);
  }
}
