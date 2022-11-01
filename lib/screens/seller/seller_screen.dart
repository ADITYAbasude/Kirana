import 'package:flutter/material.dart';
import 'package:grocery_app/screens/seller/add_seller_detail_screen.dart';

class SellerScreen extends StatefulWidget {
  SellerScreen({Key? key}) : super(key: key);

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
          behavior: ScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.glow),
          child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      child: Image.asset("assets/images/revenue.jpg"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: const Text(
                        "Launch your business in just a minute",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Container(
                  // margin: EdgeInsets.only(top: 20),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(RouteTranslation());
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      child: const Text("Continue as a seller")),
                )
              ],
            ),
          ))),
    );
  }

  Route RouteTranslation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddSellerDetailScreen(),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutExpo;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }));
  }
}
