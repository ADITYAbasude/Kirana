import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_app/tools/Toast.dart';

import '../constants/SystemColors.dart';

class AddReviewWidget extends StatelessWidget {
  AddReviewWidget(this.productData);
  final productData;
  final _review = TextEditingController();

  int _ratingByUser = 0;
  int _productRating = 0;

  void _addReview() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference _dbRef = FirebaseDatabase.instance.ref(
        'sellers/${productData['seller_id']}/products/${productData['product_id']}');
    var pushKey = _dbRef.push().key;
    if (_ratingByUser > 0 && _review.text.isNotEmpty) {
      _productRating = int.parse(productData['rating']) + _ratingByUser;

      // review data map
      Map<String, dynamic> addReview = {
        'user_id': uid,
        'rated': _ratingByUser,
        'review': _review.text,
        'product_id': productData['product_id'],
        'seller_id': productData['seller_id'],
        'review_id': pushKey
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: const Text(
              "What do you think?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "please give your rating by clicking on the stars below",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          RatingBar(
              glowColor: Colors.yellow[500],
              ratingWidget: RatingWidget(
                  empty: Icon(
                    Icons.star_border_rounded,
                    color: Colors.yellow[800],
                  ),
                  half: Icon(
                    Icons.star_half_rounded,
                    color: Colors.yellow[800],
                  ),
                  full: Icon(
                    Icons.star_rounded,
                    color: Colors.yellow[800],
                  )),
              onRatingUpdate: (value) {
                _ratingByUser = value.toInt();
              }),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
                maxLines: 6,
                controller: _review,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    hintText: "Tell us about your experience",
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(10)))),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                onPressed: () {
                  _addReview();
                },
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  "Send",
                  style: TextStyle(color: textColor),
                )),
          )
        ],
      ),
    );
  }
}
