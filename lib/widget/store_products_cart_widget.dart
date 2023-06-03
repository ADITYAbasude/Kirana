// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/utils/screen_route_translation.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/utils/add_cart_functions.dart';

import '../utils/screen_size.dart';
import '../screens/home/product_detail_screen.dart';

class StoreProductsCartWidget extends StatelessWidget {
  final productInfo;
  const StoreProductsCartWidget(this.productInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            Navigator.push(context,
                screenRouteTranslation(ProductDetailScreen(productInfo)));
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
                    child: productInfo != null
                        ? Image.network(
                            productInfo['product_image'],
                            width: 100,
                            fit: BoxFit.fitHeight,
                          )
                        : Image.asset('assets/images/fruit.png'),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (getScreenSize(context).width / 2) - 70,
                              child: Text(
                                productInfo != null
                                    ? productInfo['product_name']
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
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productInfo != null
                                    ? productInfo['product_unit'] == '/ 1 pc'
                                        ? '1 pc'
                                        : '500gr'
                                    : "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      productInfo != null
                                          ? '₹ ${productInfo['product_price']}'
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(productInfo['product_description'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.left),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            addToCart(productInfo, context);
          },
          heroTag: productInfo['product_id'],
          child: Icon(Icons.add_shopping_cart_rounded),
        ),
      ),
    );
  }
}
