import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: ScrollConfiguration(
            behavior: const ScrollBehavior(
                androidOverscrollIndicator: AndroidOverscrollIndicator.glow),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Image(
                        image: AssetImage("assets/images/user.png"),
                        width: 130,
                      ),
                      Positioned(
                          bottom: 5,
                          right: 8,
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 30,
                            color: Colors.black.withOpacity(0.5),
                          ))
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        right: 40, left: 40, top: 50, bottom: 30),
                    // ignore: prefer_const_constructors
                    child: TextField(
                      decoration:
                          // ignore: prefer_const_constructors
                          InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "User Name"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 40, left: 40),
                    // ignore: prefer_const_constructors
                    child: TextField(
                      maxLines: 2,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      minLines: 1,
                      decoration:
                          // ignore: prefer_const_constructors
                          InputDecoration(
                        hintText: "PickUp Address",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
