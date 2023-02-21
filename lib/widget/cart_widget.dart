import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/get_info.dart';
import 'package:grocery_app/tools/Toast.dart';

import '../constants/ConstantValue.dart';
import '../screens/home/product_detailed_screen.dart';

class CartWidget extends StatefulWidget {
  final cart;
  final Function cartListCallBack;
  final int index;
  final Function updateProductPriceCallback;
  final Function updateCartListDataCallback;
  const CartWidget(this.cart, this.cartListCallBack, this.index,
      this.updateProductPriceCallback, this.updateCartListDataCallback);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  var productinfo;
  String unit = "";
  int productQuantity = 1;
  @override
  void initState() {
    _getProductInfo();
    super.initState();
    productQuantity = widget.cart['product_quantity'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, _productRouteTranslation(productinfo));
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
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        IconButton(
                            onPressed: () {
                              _removeProductFromCart();
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: productQuantity != 1
                                ? () {
                                    if (productQuantity > 1) {
                                      setState(() {
                                        productQuantity--;
                                      });
                                      _updateProductQuantity();
                                    }
                                  }
                                : null,
                            icon: const Icon(
                              Icons.remove_rounded,
                              size: 16,
                            )),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: const Border.fromBorderSide(BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1)))),
                            child: Text(productQuantity.toString())),
                        IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                productQuantity++;
                              });
                              _updateProductQuantity();
                            },
                            icon: const Icon(
                              Icons.add_rounded,
                              size: 16,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getProductInfo() async {
    await FirebaseDatabase.instance
        .ref(
            'sellers/${widget.cart['seller_id']}/products/${widget.cart['product_id']}/info')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          productinfo = value.value as Map;
          widget.updateProductPriceCallback(
              double.parse(productinfo['product_price']), widget.index);
          if (productinfo['product_unit'] == '/ 1 pc') {
            unit = '1 pc';
          } else {
            unit = '500gr';
          }
        });
      }
    });
  }

  void _updateProductQuantity() async {
    await FirebaseDatabase.instance
        .ref('users/${uid}/cart/${widget.cart['product_id']}')
        .update({'product_quantity': productQuantity}).then((value) {
      widget.updateCartListDataCallback(productQuantity, widget.index);
    });
  }

  void _removeProductFromCart() async {
    await FirebaseDatabase.instance
        .ref('users/${uid}/cart/${widget.cart['product_id']}')
        .remove()
        .then((value) {
      widget.cartListCallBack(widget.index);
    });
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
