// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/constants/ConstantValue.dart';
import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/utils/get_info.dart';
import 'package:Kirana/widget/cart_widget.dart';

import '../../tools/loading.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
  static List carts = [];
}

// db reference
DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/${uid}/cart');

class _CartScreenState extends State<CartScreen> {
  // list of carts
  static List productPrice = [];
  // sub total Price
  double subTotalPrice = 0;

  //shipping charges
  double shippingCharges = 10.0;

  // total price = subtotalPrice + shipping charge's
  double totalPrice = 0;

  bool _showProgressBar = false;

  updateSubTotalPriceCallback(double price, int index) {
    setState(() {
      productPrice.add(price);
    });
    calculateThePriceOfProduct();
  }

  removeProductFromCartListCallback(int index) {
    setState(() {
      CartScreen.carts.removeAt(index);
      productPrice.removeAt(index);
    });
    print(CartScreen.carts);
    print(productPrice);
    calculateThePriceOfProduct();
  }

  updateProductQuantityCallback(int quantity, int index) {
    setState(() {
      CartScreen.carts.elementAt(index)['product_quantity'] = quantity;
    });
    calculateThePriceOfProduct();
  }

  void calculateThePriceOfProduct() {
    // subTotalPrice = 0;
    // print("cartlist lenL: ${CartScreen.carts.length}");
    // setState(() {
    //   subTotalPrice += CartScreen.carts.elementAt(index)['product_quantity'] *
    //       productPrice[index];
    //   print('SubTotal price: ${subTotalPrice}');
    // });
    // setState(() {
    //   totalPrice = subTotalPrice + shippingCharges;
    // });

    subTotalPrice = 0;
    for (int i = 0; i < productPrice.length; i++) {
      print("index $i");
      print(CartScreen.carts.elementAt(i)['product_quantity']);
      print(productPrice[i]);
      subTotalPrice +=
          CartScreen.carts.elementAt(i)['product_quantity'] * productPrice[i];
    }
    setState(() {
      totalPrice = subTotalPrice + shippingCharges;
    });
  }

  @override
  void initState() {
    _showProgressBar = true;
    _getProductsFromCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Cart",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height: getScreenSize(context).height,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: CartScreen.carts.length,
                  itemBuilder: (context, index) {
                    return CartWidget(
                        CartScreen.carts[index],
                        removeProductFromCartListCallback,
                        index,
                        updateSubTotalPriceCallback,
                        updateProductQuantityCallback);
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 1, 20),
                        width: getScreenSize(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      'Subtotal',
                                    ),
                                  ),
                                  Text(
                                    '₹ ${subTotalPrice}',
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      'Shipping charges',
                                    ),
                                  ),
                                  Text(
                                    '₹ ${shippingCharges}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 3, 9),
                        child: Divider(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹ ${totalPrice}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {},
                          icon: Icon(
                            Icons.shopping_cart_checkout_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Checkout',
                            style: TextStyle(color: textColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              visible: _showProgressBar,
              child: Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Loading(),
                  )))
        ],
      ),
    );
  }

  void _getProductsFromCart() async {
    CartScreen.carts.clear();
    await dbRef.get().then((value) {
      if (value.exists) {
        for (var data in value.children) {
          setState(() {
            CartScreen.carts.add(data.value);
          });
        }
      }
      setState(() {
        _showProgressBar = false;
      });
    }).onError((error, stackTrace) {
      _showProgressBar = false;
    });
  }
}
