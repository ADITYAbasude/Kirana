// ignore: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use, avoid_print, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/splash/splash_screen.dart';
import 'package:grocery_app/screens/home/search_screen.dart';
import 'package:grocery_app/widget/product_card_widget.dart';
import 'package:grocery_app/widget/store_card_widget.dart';
import 'package:grocery_app/utils/get_info.dart';

import '../../tools/loading.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String uid = FirebaseAuth.instance.currentUser!.uid;

var storageAccessStatus;

bool _showProgressBar = false;

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

class _HomeScreenState extends State<HomeScreen> {
  Future<dynamic> username = UserData.userName(uid);

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
              SplashScreen.address,
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
      body: Stack(
        children: [
          ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
                child: Column(
                  children: [
                    Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
              SplashScreen.nearestStoreList.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        "Nearest Store",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text(""),
              SplashScreen.nearestStoreList.isNotEmpty
                  ? Container(
                      height: 200,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: SplashScreen.nearestStoreList.length,
                        itemBuilder: (context, index) {
                          return StoreCardWidget(
                              SplashScreen.nearestStoreList[index]);
                        },
                      ),
                    )
                  : Text(''),
              SplashScreen.products.isNotEmpty
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Text(
                        "Popular Deals",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text(''),
              SplashScreen.products.isNotEmpty
                  ? Container(
                      height: 250,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: SplashScreen.products.length,
                        itemBuilder: (context, index) {
                          return ProductCardWidget(
                              SplashScreen.products[index]);
                        },
                      ),
                    )
                  : Text(''),
            ],
          ),
          Visibility(
              visible: _showProgressBar,
              child: Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Loading(),
                  )))
        ],
      ),
    );
  }

  Route _searchRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
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
}
