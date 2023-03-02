import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/utils/get_info.dart';
import 'package:grocery_app/widget/favorite_product_cart_widget.dart';
import 'package:grocery_app/widget/wishlist_is_empty.dart';

import '../../constants/ConstantValue.dart';
import '../../constants/SystemColors.dart';

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({Key? key}) : super(key: key);
  static List favoriteProductList = [];
  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  @override
  void initState() {
    _getFavoriteProducts();
    super.initState();
  }

  removeProductFromFavoriteListCallback(int index) {
    setState(() {
      MyFavoritesScreen.favoriteProductList.removeAt(index);
    });
  }

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
        body: MyFavoritesScreen.favoriteProductList.isNotEmpty
            ? SizedBox(
                height: getScreenSize(context).height,
                child:
                    ListView(physics: const ClampingScrollPhysics(), children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: MyFavoritesScreen.favoriteProductList.length,
                    itemBuilder: (context, index) {
                      return FavoriteProductCartWidget(
                          MyFavoritesScreen.favoriteProductList[index],
                          removeProductFromFavoriteListCallback,
                          index);
                    },
                  ),
                ]))
            : WishlistIsEmpty());
  }

  void _getFavoriteProducts() async {
    MyFavoritesScreen.favoriteProductList.clear();
    FirebaseDatabase.instance.ref('users/${uid}/favorite').get().then((value) {
      if (value.exists) {
        for (var product in value.children) {
          if (product.exists) {
            setState(() {
              MyFavoritesScreen.favoriteProductList.add(product.value);
            });
          }
        }
      }
    });
  }
}
