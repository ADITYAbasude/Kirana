import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewCardWidget extends StatefulWidget {
  ReviewCardWidget(this.allReviews);
  final allReviews;

  @override
  State<ReviewCardWidget> createState() => _ReviewCardWidgetState();
}

class _ReviewCardWidgetState extends State<ReviewCardWidget> {
  String username = "";
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.allReviews['date'].toString()));
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  // '${date.day}/${date.month}/${date.year}',
                  DateFormat("dd/MM/yyyy").format(date),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          RatingBarIndicator(
              unratedColor: Colors.grey[400],
              rating: double.parse(widget.allReviews['rated'].toString()),
              itemSize: 10,
              itemBuilder: (context, index) => Icon(
                    Icons.star_rounded,
                    color: Colors.yellow[800],
                  )),
          Container(
            margin: const EdgeInsets.only(top: 5, left: 5),
            child: Text(widget.allReviews['review'],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  void getUserName() async {
    await FirebaseDatabase.instance
        .ref('users')
        .child(widget.allReviews['user_id'])
        .child('info')
        .get()
        .then((value) {
      var data = value.value as Map;
      if (this.mounted) {
        setState(() {
          username = data['name'];
        });
      }
    });
  }
}
