import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/tools/Toast.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final nameList = ["Saved address", "Account setting", "Support", "About"];

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(10),
              expandedTitleScale: 1,
              title: Text(
                'Person',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              background: Image(
                image: AssetImage("assets/images/user.png"),
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Add new entry',
                onPressed: () {/* ... */},
              ),
            ]),

        SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, index) {
          return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Text(
                      nameList[index],
                      style: TextStyle(fontSize: 20),
                      // textScaleFactor: 2,
                    ),
                    onTap: () {
                      MakeToast().showToast("clicked");
                    },
                  ),
                  Container(
                      width: double.infinity,
                      child: Divider(
                          // color: Colors.black,
                          ))
                ],
              ));
        }, childCount: nameList.length)
            // SliverChildBuilderDelegate(
            //   (BuildContext context, int index) {
            //     return Container(
            //       height: 100.0,
            //       child: Center(
            //         child: Text('$index', textScaleFactor: 5),
            //       ),
            //     );
            //   },
            //   childCount: 20,
            // ),
            ),
        //   children: [
        // Stack(
        //   alignment: Alignment.center,
        //   children: [
        //     const Image(
        //       image: AssetImage("assets/images/user.png"),
        //       width: 130,
        //     ),
        //     Positioned(
        //         bottom: 5,
        //         right: 8,
        //         child: Icon(
        //           Icons.add_a_photo_outlined,
        //           size: 30,
        //           color: Colors.black.withOpacity(0.5),
        //         ))
        //   ],
        // ),
        // Container(
        //   margin: const EdgeInsets.only(
        //       right: 40, left: 40, top: 50, bottom: 30),
        //   // ignore: prefer_const_constructors
        //   child: TextField(
        //     decoration:
        //         // ignore: prefer_const_constructors
        //         InputDecoration(
        //             border: const OutlineInputBorder(),
        //             hintText: "User Name"),
        //   ),
        // // ),
        // Container(
        //   margin: const EdgeInsets.only(right: 40, left: 40),
        //   // ignore: prefer_const_constructors
        //   child: TextField(
        //     maxLines: 2,
        //     maxLengthEnforcement: MaxLengthEnforcement.enforced,
        //     minLines: 1,
        //     decoration:
        //         // ignore: prefer_const_constructors
        //         InputDecoration(
        //       hintText: "PickUp Address",
        //       border: const OutlineInputBorder(),
        //     ),
        //   ),
        // )
        //   ],
        // )),
      ],
    ));
  }
}
