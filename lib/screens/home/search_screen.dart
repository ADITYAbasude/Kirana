import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/SystemColors.dart';
import 'package:grocery_app/constants/get_info.dart' as user hide uid;

import '../../tools/Toast.dart';
import '../seller/seller_home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static List sellers = [];

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

final _searchController = TextEditingController();

bool searchTextFieldClearOption = false;

// database references
DatabaseReference ref = FirebaseDatabase.instance.ref('sellers');

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mainColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Container(
            height: 50,
            child: TextField(
              textInputAction: TextInputAction.search,
              controller: _searchController,
              onSubmitted: (value) {
                _searchResult();
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    searchTextFieldClearOption = true;
                  });
                }
              },
              style: TextStyle(color: textColor),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 20, left: 10, right: 5),
                suffix: Visibility(
                  visible: searchTextFieldClearOption,
                  child: IconButton(
                      onPressed: () {
                        _searchController.text = "";
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      )),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2)),
              ),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ))),
    );
  }

  void _searchResult() async {
    SearchScreen.sellers.clear();

    ref.get().then((value) {
      for (var snap in value.children) {
        snap.ref.child('info').get().then((value) {
          var data = value.value as Map;
          if (data['shop_name'] == 'birju pav bhaji') {
            showToast(data['shop_name']);
          }
        });
      }
    });
  }
}
