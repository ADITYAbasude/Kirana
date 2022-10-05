import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
                child: OtpTextField(
                  numberOfFields: 6,
                  showFieldAsBox: true,
                  focusedBorderColor: Theme.of(context).primaryColor,
                )),
            Container(
                margin: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTPScreen()))
                        },
                    child: const Text("Continue")))
          ])),
        ));
  }
}
