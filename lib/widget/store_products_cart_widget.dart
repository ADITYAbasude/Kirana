// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grocery_app/utils/add_cart_functions.dart';

import '../constants/ConstantValue.dart';
import '../screens/home/product_detailed_screen.dart';

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
            Navigator.push(context, _productRouteTranslation(productInfo));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: Color.fromARGB(78, 0, 0, 0),
                      offset: Offset(0, 0))
                ]),
            width: getScreenSize(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
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

  Route _productRouteTranslation(var productData) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailedScreen(productData),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.fastOutSlowIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }));
  }
}
