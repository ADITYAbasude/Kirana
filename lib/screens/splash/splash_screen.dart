// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/screens/auth/login_signup_screen.dart';
import 'package:grocery_app/screens/main_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:grocery_app/utils/distanceCalculator.dart';
import 'package:grocery_app/utils/get_permissions.dart';

import 'package:location/location.dart' as loc hide PermissionStatus;

import '../../utils/get_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static List nearestStoreList = [];
  static List products = [];
  static String address = "";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

loc.Location location = loc.Location();

class _SplashScreenState extends State<SplashScreen> {
  User? auth = FirebaseAuth.instance.currentUser;
  var locationAccessStatus;
  static Position? currentLocation;

  bool _showProgressBar = true;

  // firebase database ref
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('sellers');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      LocationAccess();
    }).whenComplete(() {
      _getNearestStore();
    });
  }

  LocationAccess() async {
    locationAccessStatus = await Permission.location.status;

    if (await locationAccessStatus == PermissionStatus.granted) {
      await GetPermissions().RequestGpsService().then((value) {
        _getCurrentAddress();
      });
    } else {
      await GetPermissions().LocationAccessRequest().then((value) async {
        if (await locationAccessStatus == PermissionStatus.granted) {
          await GetPermissions().RequestGpsService().then((value) {
            _getCurrentAddress();
          });
        }
      });
    }
  }

  Future<void> _getCurrentAddress() async {
    if (await location.serviceEnabled() ||
        await Permission.location.status == PermissionStatus.granted) {
      currentLocation = await UserData.locateUser();
      await placemarkFromCoordinates(
              currentLocation!.latitude, currentLocation!.longitude,
              localeIdentifier: 'en')
          .then(
        (List<Placemark> placeMarks) {
          Placemark place = placeMarks[0];
          setState(() {
            SplashScreen.address =
                '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
          });
        },
      );
    }
  }

  void _getNearestStore() async {
    _showProgressBar = true;
    SplashScreen.nearestStoreList.clear();
    SplashScreen.products.clear();
    if (await Permission.location.status == PermissionStatus.granted) {
      await _dbRef.get().then((value) async {
        for (var snapshot in value.children) {
          await snapshot.ref.child('info').get().then((value) async {
            var data = value.value as Map;
            Position location1 = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            // print(data);
            double distance = getDistance(location1, double.parse(data['lat']),
                double.parse(data['lng']));
            if ((distance / 1000).round() < 4) {
              setState(() {
                SplashScreen.nearestStoreList.add(data);
              });
              await snapshot.ref.child('products').get().then((value) async {
                for (var snapshot in value.children) {
                  await snapshot.ref.child('info').get().then((value) {
                    var product = value.value as Map;
                    setState(() {
                      SplashScreen.products.add(product);
                    });
                  });
                }

                // if (SplashScreen.products.length == value.children.length) {}
                setState(() {
                  _showProgressBar = false;
                });
              });
            }
          });
        }
      }).whenComplete(() {
        SplashScreen.nearestStoreList.shuffle();
        SplashScreen.products.shuffle();
      }).onError((error, stackTrace) {
        _showProgressBar = false;
      });
    }
  }

  @override
  // ignore: duplicate_ignore
  Widget build(BuildContext context) {
    if (_showProgressBar == false) {
      Timer(
          Duration(seconds: 1),
          () => {
                // ignore: unnecessary_null_comparison
                if (auth != null)
                  {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainScreen()))
                  }
                else
                  {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginSignUpScreen()))
                  }

                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => CartScreen()))
              });
    }
    // ignore: prefer_const_constructor
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(image: AssetImage('assets/icons/store.png'), width: 100),
        Container(
            padding: EdgeInsets.only(top: 5), child: Text("#AabAapKiApniDukan"))
      ])),
    );
  }
}
