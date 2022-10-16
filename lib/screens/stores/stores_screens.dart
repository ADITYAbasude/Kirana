// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:grocery_app/constants/GetPermissions.dart';
import 'package:grocery_app/states/States.dart';
import 'package:location/location.dart' as loc hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';

class StoresScreen extends StatefulWidget {
  StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

var locationAccessStatus;
var storageAccessStatus;

loc.Location location = loc.Location();

class _StoresScreenState extends State<StoresScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // location access
      LocationAccess();
    });
  }

  Widget build(BuildContext context) {
    return Container(
        child: ScrollConfiguration(
      behavior: ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      child: SingleChildScrollView(
          child: Column(
        children: [],
      )),
    ));
  }

  LocationAccess() async {
    locationAccessStatus = await Permission.location.status;
    // storageAccessStatus = await Permission.storage.status;

    if (locationAccessStatus == PermissionStatus.granted) {
      print("Granted");
    } else {
      GetPermissions().LocationAccessRequest();
    }

    // if (storageAccessStatus == PermissionStatus.granted) {
    //   print("Granted");
    // } else {
    //   GetPermissions().StorageAccessRequest();
    // }
  }

  void ShowBottomSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
                color: Colors.white,
                // ignore: prefer_const_constructors
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Column(
              children: [
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    onPressed: () {},
                    icon: Icon(Icons.my_location_rounded),
                    label: const Text(
                      "Your Location",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          );
        });
  }

  Future RequestGpsService() async {
    if (!await location.serviceEnabled()) {
      location.requestService();
    }
  }
}
