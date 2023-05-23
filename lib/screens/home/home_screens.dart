// ignore: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use, avoid_print, duplicate_ignore, prefer_final_fields

import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/screens/home/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';
import 'package:Kirana/screens/home/search_screen.dart';
import 'package:Kirana/widget/product_card_widget.dart';
import 'package:Kirana/widget/store_card_widget.dart';
import 'package:Kirana/utils/get_info.dart';

import '../../tools/loading.dart';
import '../../utils/screen_route_translation.dart';

class HomeScreen extends StatefulWidget {
  final Function callbackNearestStoreAndProductFunction;
  HomeScreen(this.callbackNearestStoreAndProductFunction);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var storageAccessStatus;

  bool _showProgressBar = false;

  List<Color> categoriesColors = [
    Colors.green.shade50,
    Colors.red.shade50,
    Colors.yellow.shade50,
    Colors.pink.shade50,
    Colors.orange.shade50,
    Colors.deepOrange.shade50,
  ];

  final categoriesName = [
    "Vegetable",
    "Fruit",
    "Beverage",
    "Household",
    "Snack",
    "Dairy"
  ];
  final categoriesIcons = [
    "assets/icons/vegetable.png",
    "assets/icons/fruit.png",
    "assets/icons/beverage.png",
    "assets/icons/household.png",
    "assets/icons/snack.png",
    "assets/icons/dairy.png"
  ];

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
                Navigator.push(context, screenRouteTranslation(SearchScreen()));
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
                      itemCount: categoriesName.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  screenRouteTranslation(
                                      CategoriesScreen(categoriesName[index])));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: const EdgeInsets.all(20),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: categoriesColors[index],
                                  borderRadius: BorderRadius.circular(50)),
                              child: Image.asset(
                                categoriesIcons[index],
                                width: 40,
                                height: 40,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
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
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Text(
                  "Nearest Store",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
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
                  : Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            "Sorry, We could not found any nearest store from your location.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      screenRouteTranslation(SearchScreen()));
                                },
                                icon: Icon(Icons.search_rounded),
                                label: Text("Search store")),
                          )
                        ],
                      ),
                    ),
              SplashScreen.products.isNotEmpty
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Text(
                        "Products from nearest store",
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
}
