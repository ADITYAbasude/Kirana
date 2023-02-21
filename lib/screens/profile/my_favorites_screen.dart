import 'package:flutter/material.dart';

import '../../constants/SystemColors.dart';

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({Key? key}) : super(key: key);

  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Favorites",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset('image/my_fav.JPG'),
            Text(
              "Oops your wishlist is empty!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                child: Text(
                    "It seems nothing in here, Explore more and shortlist some item"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF24B329),
                    minimumSize: Size(300, 50),
                  ),
                  onPressed: () {},
                  child: Text("Start Shopping")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Recommendation for you",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: TextStyle(color: Color(0xFF24B329)),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.grey[400],
                  height: 180,
                  width: 130,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.grey[400],
                  height: 180,
                  width: 130,
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
