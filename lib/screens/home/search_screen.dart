import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/utils/screen_size.dart';
import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/tools/loading.dart';
import 'package:Kirana/widget/product_card_widget.dart';

import '../../widget/store_card_widget.dart';

class SearchScreen extends StatefulWidget {
  static List sellers = [];
  static List products = [];

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

final _searchController = TextEditingController();

bool searchTextFieldClearOption = false;

// database references
DatabaseReference ref = FirebaseDatabase.instance.ref('sellers');

class _SearchScreenState extends State<SearchScreen> {
  bool _loadingVisibility = false;
  bool _showShops = false;
  bool _showProducts = false;
  @override
  Widget build(BuildContext context) {
    final double itemWidth = getScreenSize(context).width / 1.9;
    final double itemHeight =
        (getScreenSize(context).height - kToolbarHeight - 24) / 2.6;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: mainColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: SizedBox(
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
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Visibility(
                    visible: _showShops,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: SearchScreen.sellers.length,
                        itemBuilder: (context, index) {
                          return StoreCardWidget(SearchScreen.sellers[index]);
                        },
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _showProducts,
                      child: GridView.builder(
                          padding: const EdgeInsets.all(5),
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: SearchScreen.products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: itemWidth / itemHeight),
                          itemBuilder: (context, index) {
                            return ProductCardWidget(
                                SearchScreen.products[index]);
                          }))
                ],
              )),
            ),
            Visibility(
              visible: !(_showShops || _showProducts),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/search_not_found.png"),
                    const Text(
                      "Oops...! Search not found 🧐",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: _loadingVisibility,
                child: Center(
                  child: Loading(),
                ))
          ],
        ));
  }

  void _searchResult() async {
    SearchScreen.sellers.clear();
    SearchScreen.products.clear();

    // searching a shop but there is no restriction on address of that shop, it will search all over the world.
    setState(() {
      _loadingVisibility = true;
    });
    await FirebaseDatabase.instance.ref('sellers').get().then((value) async {
      for (var data in value.children) {
        await data.ref.child("info").get().then((value) {
          var shopData = value.value as Map;
          if (shopData['shop_name']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())) {
            setState(() {
              SearchScreen.sellers.add(shopData);
              _loadingVisibility = true;
            });
          }
        }).whenComplete(() {
          if (SearchScreen.sellers.isEmpty) {
            _showShops = false;
          } else {
            _showShops = true;
          }
        });

        await data.ref.child('products').get().then((value) async {
          for (var product in value.children) {
            await product.ref.child('info').get().then((value) {
              var productData = value.value as Map;
              if (productData['product_name']
                  .toString()
                  .contains(_searchController.text)) {
                setState(() {
                  SearchScreen.products.add(productData);
                });
              }
            });
          }
        }).whenComplete(() {
          if (SearchScreen.products.isEmpty) {
            _showProducts = false;
          } else {
            _showProducts = true;
          }
        });
      }
    });
    setState(() {
      _loadingVisibility = false;
    });
  }
}
