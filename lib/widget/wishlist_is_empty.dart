import 'package:flutter/material.dart';

class WishlistIsEmpty extends StatelessWidget {
  const WishlistIsEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Oops your wishlist is empty!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
              child: Text(
                "It seems nothing in here, Explore more and shortlist some item",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
