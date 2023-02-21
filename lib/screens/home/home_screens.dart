// ignore: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use, avoid_print, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grocery_app/constants/distanceCalculator.dart';
import 'package:grocery_app/constants/get_permissions.dart';
import 'package:grocery_app/screens/home/product_detailed_screen.dart';
import 'package:grocery_app/screens/home/search_screen.dart';
import 'package:grocery_app/widget/product_card_widget.dart';
import 'package:grocery_app/widget/store_card_widget.dart';
import 'package:location/location.dart' as loc hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/constants/get_info.dart';

class HomeScreen extends StatefulWidget {
  static List nearestStoreList = [];
  static List products = [];
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

// firebase database ref
DatabaseReference _dbRef = FirebaseDatabase.instance.ref('sellers');

class _HomeScreenState extends State<HomeScreen> {
  static Position? currentLocation;
  static String address = "";

  Future<dynamic> username = UserData.userName(uid);
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // location access
      LocationAccess();
    }).whenComplete(() {
      _getNearestStore();
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
              onPressed: () {
                Navigator.push(context, _searchRouteTranslation());
              },
              icon: Icon(
                Icons.search_rounded,
                color: Colors.white,
              ))
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
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
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
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
                  })),
          HomeScreen.nearestStoreList.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "Nearest Store",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : Text(""),
          HomeScreen.nearestStoreList.isNotEmpty
              ? Container(
                  height: 200,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: HomeScreen.nearestStoreList.length,
                    itemBuilder: (context, index) {
                      return StoreCardWidget(
                          HomeScreen.nearestStoreList[index]);
                    },
                  ),
                )
              : Text(''),
          HomeScreen.products.isNotEmpty
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    "Popular Deals",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : Text(''),
          HomeScreen.products.isNotEmpty
              ? Container(
                  height: 250,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: HomeScreen.products.length,
                    itemBuilder: (context, index) {
                      return ProductCardWidget(HomeScreen.products[index]);
                    },
                  ),
                )
              : Text(''),
        ],
      ),
    );
  }

  LocationAccess() async {
    locationAccessStatus = await Permission.location.status;

    if (locationAccessStatus == PermissionStatus.granted) {
      await GetPermissions().RequestGpsService().then((value) {
        _getCurrentAddress();
      });
    } else {
      await GetPermissions().LocationAccessRequest().then((value) async {
        await GetPermissions().RequestGpsService();
      });
    }
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
                currentLocation!.latitude, currentLocation!.longitude,
                localeIdentifier: 'en')
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

  Route _searchRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchScreen(),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.fastOutSlowIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }));
  }

  void _getNearestStore() async {
    HomeScreen.nearestStoreList.clear();
    HomeScreen.products.clear();
    await _dbRef.get().then((value) async {
      for (var snapshot in value.children) {
        await snapshot.ref.child('info').get().then((value) async {
          var data = value.value as Map;
          Position location1 = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          // print(data);
          double distance = getDistance(
              location1, double.parse(data['lat']), double.parse(data['lng']));
          if ((distance / 1000).round() < 4) {
            setState(() {
              HomeScreen.nearestStoreList.add(data);
            });
            await snapshot.ref.child('products').get().then((value) async {
              for (var snapshot in value.children) {
                await snapshot.ref.child('info').get().then((value) {
                  var product = value.value as Map;
                  setState(() {
                    HomeScreen.products.add(product);
                  });
                });
              }
            });
          }
        });
      }
    }).whenComplete(() {
      HomeScreen.nearestStoreList.shuffle();
      HomeScreen.products.shuffle();
    });
  }
}
