// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:Kirana/utils/screen_route_translation.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/screens/home/store_screen.dart';

class StoreCardWidget extends StatelessWidget {
  StoreCardWidget(this.shopData);
  var shopData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, screenRouteTranslation(StoreScreen(shopData)));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: mainColor.withOpacity(0.1),
          ),
          child: Column(
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
                      right: 10,
                      child: Text(
                        shopData['shop_name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
              ])
            ],
          )),
    );
  }
}
