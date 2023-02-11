import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/ConstantValue.dart';
import 'package:grocery_app/constants/SystemColors.dart';
import 'package:grocery_app/screens/orders/orders_screen.dart';
import 'package:grocery_app/screens/profile/my_address_screen.dart';
import 'package:grocery_app/screens/profile/my_favorites_screen.dart';
import 'package:grocery_app/screens/profile/my_profile_screen.dart';
import 'package:grocery_app/screens/profile/notification_screen.dart';
import 'package:grocery_app/screens/seller/seller_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/user_info.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// data
final nameList = [
  "My Profile",
  "Switch Seller",
  "My Address",
  "My Orders",
  "Notification",
  "Help Center",
  "Log Out"
];
final icons = [
  Icons.account_circle_outlined,
  Icons.storefront_outlined,
  Icons.map_outlined,
  Icons.shopping_bag_outlined,
  Icons.notifications_outlined,
  Icons.help_center_outlined,
  Icons.logout_outlined
];
final differentColors = [
  Colors.green,
  Colors.deepPurple,
  Colors.cyan,
  Colors.black,
  Colors.yellow,
  Colors.amber,
  Colors.red
];

class _ProfileScreenState extends State<ProfileScreen> {
  Future<dynamic> username = UserData.userName(uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Profile",
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
          backgroundColor: mainColor,
        ),
        body: Container(
          height: getScreenSize(context).height,
          width: getScreenSize(context).width,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(children: [
                // user img
                Container(
                  child: Stack(
                    children: [
                      Container(
                          child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(100)),
                      )),
                      Visibility(
                          visible: true,
                          child: Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ))))
                    ],
                  ),
                ),

                // user name
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: FutureBuilder(
                      future: username,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const Text(
                            "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              // fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                      }),
                ),

                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.8,
                ),
              ]),
            ),
            ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: nameList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      switch (index) {
                        case 0:
                          Navigator.of(context)
                              .push(_myProfileRouteTranslation());
                          break;
                        case 1:
                          Navigator.of(context)
                              .push(_sellerStoreRouteTranslation());
                          break;
                        case 2:
                          Navigator.of(context)
                              .push(_myAddressRouteTranslation());
                          break;
                        case 3:
                          Navigator.of(context)
                              .push(_myOrderRouteTranslation());
                          break;
                        case 4:
                          Navigator.of(context)
                              .push(_myNotificationRouteTranslation());
                          break;
                        case 5:
                          Navigator.of(context)
                              .push(_myProfileRouteTranslation());
                          break;
                        case 6:
                          logOut(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(58, 240, 234, 234),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: differentColors
                                      .elementAt(index)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Icon(
                                icons.elementAt(index),
                                color: differentColors.elementAt(index),
                              )),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              nameList.elementAt(index),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_right_rounded)
                        ],
                      ),
                    ),
                  );
                })
          ]),
        ));
  }

  void logOut(BuildContext context) {
    FirebaseAuth.instance.signOut().whenComplete(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("seller");
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  Route _myProfileRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MyProfileScreen(),
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

  Route _sellerStoreRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SellerScreen(),
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

  Route _myOrderRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => OrderScreen(),
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

  Route _myAddressRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MyAddressScreen(),
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

  Route _myNotificationRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NotificationScreen(),
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

  Route _myFavoritesRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MyFavoritesScreen(),
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
