import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:grocery_app/screens/auth/login_signup_screen.dart';
import 'package:grocery_app/screens/main_screen.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 2,
          title: const Text("OTP Verificaton"),
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
          child: SingleChildScrollView(
              child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Image.asset("assets/images/otpAnim.gif"),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
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
                animationDuration: Duration(microseconds: 500),
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
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
                                builder: (context) => MainScreen()));
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
