// ignore: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use, avoid_print, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_app/constants/get_permissions.dart';
import 'package:location/location.dart' as loc hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/constants/user_info.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String uid = FirebaseAuth.instance.currentUser!.uid;

var locationAccessStatus;
var storageAccessStatus;

List<Color> categoriesColors = [
  Colors.green.shade50,
  Colors.red.shade50,
  Colors.yellow.shade50,
  Colors.purple.shade50
];

final categoriesName = ["Vegetables", "Fruits", "Milks & Egg", "Meat"];
final categoriesIcons = [
  "assets/icons/vegetable.png",
  "assets/icons/fruit.png",
  "assets/icons/egg_milk.png",
  "assets/icons/meat.png"
];

loc.Location location = loc.Location();

class _HomeScreenState extends State<HomeScreen> {
  static LatLng? latlng;
  static Position? currentLocation;
  static String address = "";

  Future<String> username = UserData.userName(uid);
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // location access
      LocationAccess();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            FutureBuilder(
                future: username,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontWeight: FontWeight.w500,
                      ),
                    );
                  } else {
                    return Text(
                      "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                }),
            const SizedBox(
              height: 5,
            ),
            Text(
              address,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_rounded,
                color: Colors.white,
              ))
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
            child: Column(
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Categories",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text("")
                  ],
                )
              ],
            ),
          ),
          Container(
              height: 110,
              child: ScrollConfiguration(
                  behavior: ScrollBehavior(
                      androidOverscrollIndicator:
                          AndroidOverscrollIndicator.glow),
                  child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                color: categoriesColors[index],
                                borderRadius: BorderRadius.circular(50)),
                            child: Image.asset(categoriesIcons[index]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Text(
                              categoriesName[index],
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          )
                        ]);
                      }))),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Text(
              "Popular Deals",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 250,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                AnimatedContainer(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 0,
                              color: Color.fromARGB(78, 0, 0, 0),
                              offset: Offset(0, 0))
                        ]),
                    // padding: EdgeInsets.symmetric(horizontal: 5),
                    duration: Duration(seconds: 1),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: InkWell(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 3),
                              decoration: BoxDecoration(
                                // color: Color.fromARGB(48, 238, 238, 238),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/images/potato.jpg",
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 120,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10, left: 5),
                              child: Text(
                                "Potato",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 8,
                                    left: 5,
                                  ),
                                  child: Text(
                                    "200gr",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[800]),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.currency_rupee_rounded),
                                      Container(
                                        child: Text("50",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      floatingActionButton: FloatingActionButton.small(
                        heroTag: "btn1",
                        onPressed: () {},
                        child: Icon(Icons.add_rounded),
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.miniEndFloat,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  LocationAccess() async {
    locationAccessStatus = await Permission.location.status;
    // storageAccessStatus = await Permission.storage.status;

    if (locationAccessStatus == PermissionStatus.granted) {
      GetPermissions().RequestGpsService();
      _getCurrentAddress();
    } else {
      GetPermissions().LocationAccessRequest().then((value) {
        GetPermissions().RequestGpsService();
      });
    }

    // if (storageAccessStatus == PermissionStatus.granted) {
    //   print("Granted");
    // } else {
    //   GetPermissions().StorageAccessRequest();
    // }
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _getCurrentAddress() async {
    if (mounted) {
      if (await location.serviceEnabled()) {
        currentLocation = await locateUser();
        await placemarkFromCoordinates(
                currentLocation!.latitude, currentLocation!.longitude)
            .then(
          (List<Placemark> placeMarks) {
            Placemark place = placeMarks[0];
            setState(() {
              address =
                  '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
            });
          },
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
