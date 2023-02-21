// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/ConstantValue.dart';
import 'package:grocery_app/constants/SystemColors.dart';
import 'package:grocery_app/constants/get_info.dart';
import 'package:grocery_app/widget/cart_widget.dart';

class CartScreen extends StatefulWidget {
  // list of carts
  static List carts = [];
  static Map<int, double> productPrice = Map();

  @override
  _CartScreenState createState() => _CartScreenState();
}

// db reference
DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/${uid}/cart');

class _CartScreenState extends State<CartScreen> {
  // sub total Price
  double subTotalPrice = 0;

  //shipping charges
  double shippingCharges = 10.0;

  // total price = subtotalPrice + shipping charge's
  double totalPrice = 0;

  updateProductPriceCallback(double price, int index) {
    setState(() {
      CartScreen.productPrice[index] = price;
      subTotalPrice += price;
    });
    calculateThePriceOfProduct(index);
  }

  cartListCallback(int index) {
    setState(() {
      CartScreen.carts.removeAt(index);
    });
    calculateThePriceOfProduct(index);
  }

  updateCartListDataCallback(int quantity, int index) {
    setState(() {
      CartScreen.carts.elementAt(index)['product_quantity'] = quantity;
    });
    calculateThePriceOfProduct(index);
  }

  void calculateThePriceOfProduct(int index) {
    subTotalPrice = 0;
    for (int i = 0; i < CartScreen.carts.length; i++) {
      setState(() {
        subTotalPrice += CartScreen.carts.elementAt(index)['product_quantity'] *
            CartScreen.productPrice[index];
      });
    }
    setState(() {
      totalPrice = subTotalPrice + shippingCharges;
    });
  }

  @override
  void initState() {
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
      body: Container(
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
                    cartListCallback,
                    index,
                    updateProductPriceCallback,
                    updateCartListDataCallback);
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    child: Divider(),
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
    });
  }
}
