// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

/* 
This file is created by Aditya
copyright year 2022
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/main_screen.dart';
import 'package:Kirana/screens/seller/seller_product_detailed_screen.dart';
import 'package:Kirana/widget/product_manage_widget.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({Key? key}) : super(key: key);
  static List products = [];

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreen();
}

// bool for textfield error
// bool _productNameError = false;
// bool _productPriceError = false;

// uid of user
final _uid = FirebaseAuth.instance.currentUser!.uid;

class _SellerHomeScreen extends State<SellerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // _productStockController.text = "0";
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // some Ui calculation
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ))
          ],
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              )),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: RefreshIndicator(
            strokeWidth: 3,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "Your Product",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                GridView.builder(
                    padding: EdgeInsets.all(5),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: SellerHomeScreen.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: itemWidth / itemHeight),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  color: Color.fromARGB(78, 0, 0, 0),
                                  offset: Offset(0, 0))
                            ]),
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                  onTap: () {
                                    SellerProductDetailedScreen.index = index;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SellerProductDetailedScreen()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            SellerHomeScreen.products[index]
                                                ['product_image'],
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 120,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.all(10),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            SellerHomeScreen.products[index]
                                                ['product_name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 18),
                                          )),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.currency_rupee_rounded,
                                                size: 15,
                                              ),
                                              Text(
                                                SellerHomeScreen.products[index]
                                                    ['product_price'],
                                              ),
                                              Text(SellerHomeScreen
                                                      .products[index]
                                                  ['product_unit'])
                                            ],
                                          ))
                                    ],
                                  ))),
                          floatingActionButton: FloatingActionButton(
                            mini: true,
                            heroTag: index,
                            backgroundColor: Colors.green.shade500,
                            onPressed: () {
                              FirebaseDatabase.instance
                                  .ref(
                                      'sellers/$_uid/products/${SellerHomeScreen.products[index]['product_id']}')
                                  .remove()
                                  .whenComplete(() {
                                _getProducts();
                              });
                            },
                            child: Icon(Icons.delete_outlined),
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.miniEndTop,
                        ),
                      );
                    })
              ],
            ),
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                _getProducts();
              });
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ProductManageWidget.product_manage_status = "add";
            showModalBottomSheet(
                isDismissible: true,
                isScrollControlled: true,
                enableDrag: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.895,
                    minChildSize: 0.5,
                    maxChildSize: 0.895,
                    builder: (_, controller) {
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return ProductManageWidget(controller);
                        },
                      );
                    },
                  );
                });
          },
          elevation: 5,
          label: const Text(
            "Product",
            style: TextStyle(fontSize: 15),
          ),
          icon: const Icon(Icons.add_rounded),
        ));
  }

  void _getProducts() async {
    SellerHomeScreen.products.clear();
    await FirebaseDatabase.instance
        .ref('sellers')
        .child(_uid)
        .child('products')
        .get()
        .then((value) async {
      for (var value in value.children) {
        await value.ref.child('info').get().then((value) {
          setState(() {
            SellerHomeScreen.products.add(value.value);
          });
        });
      }
    });
  }
}
