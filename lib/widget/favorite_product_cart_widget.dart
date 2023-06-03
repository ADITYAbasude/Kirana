import 'package:Kirana/utils/screen_route_translation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/utils/get_info.dart';
import 'package:Kirana/utils/add_cart_functions.dart';

import '../utils/screen_size.dart';
import '../screens/home/product_detail_screen.dart';

class FavoriteProductCartWidget extends StatefulWidget {
  const FavoriteProductCartWidget(this.favoriteData,
      this.removeProductFromFavoriteListCallback, this.index);
  final favoriteData;
  final Function removeProductFromFavoriteListCallback;
  final index;

  @override
  _FavoriteProductCartWidgetState createState() =>
      _FavoriteProductCartWidgetState();
}

class _FavoriteProductCartWidgetState extends State<FavoriteProductCartWidget> {
  var productinfo;
  String unit = "";
  @override
  void initState() {
    _getProductInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, screenRouteTranslation(ProductDetailScreen(productinfo)));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: getScreenSize(context).width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: productinfo != null
                    ? Image.network(
                        productinfo['product_image'],
                        width: 100,
                        fit: BoxFit.fitHeight,
                      )
                    : Image.asset('assets/images/fruit.png'),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (getScreenSize(context).width / 2) - 70,
                          child: Text(
                            productinfo != null
                                ? productinfo['product_name']
                                : "",
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 17,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productinfo != null ? unit : "",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Text(
                                  productinfo != null
                                      ? '₹ ${productinfo['product_price']}'
                                      : '₹ 0',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getProductInfo() async {
    await FirebaseDatabase.instance
        .ref(
            'sellers/${widget.favoriteData['seller_id']}/products/${widget.favoriteData['product_id']}/info')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          productinfo = value.value as Map;
          if (productinfo['product_unit'] == '/ 1 pc') {
            unit = '1 pc';
          } else {
            unit = '500gr';
          }
        });
      }
    });
  }

  void _removeProductFromFavoriteList() async {
    await FirebaseDatabase.instance
        .ref('users/${uid}/favorite/${widget.favoriteData['product_id']}')
        .remove()
        .then((value) {
      widget.removeProductFromFavoriteListCallback(widget.index);
    });
  }
}
