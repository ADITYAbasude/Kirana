// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:grocery_app/constants/SystemColors.dart';
import 'package:grocery_app/screens/home/store_screen.dart';

class StoreCardWidget extends StatelessWidget {
  StoreCardWidget(this.shopData);
  var shopData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, _storeRouteTranslation());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width / 1.2,
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
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: shopData['shop_image'] != null
                          ? Image.network(shopData['shop_image'],
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.fitWidth)
                          : Image.asset('assets/images/user.png'),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(0, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                                Color.fromARGB(166, 0, 0, 0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 10,
                        child: Text(
                          shopData['shop_name'],
                          style: TextStyle(
                              fontSize: 25,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      shopData['shop_address'],
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Container(
                    width: 45,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "2",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  )
                ])
              ],
            )),
      ),
    );
  }

  Route _storeRouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StoreScreen(shopData),
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
