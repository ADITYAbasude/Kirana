// ignore_for_file: prefer_const_constructors

/* 
This file is created by Aditya
copyright year 2022
*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/tools/Toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({Key? key}) : super(key: key);
  static List products = [];

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreen();
}

// textfield controllers
final _productNameController = TextEditingController();
final _productPriceController = TextEditingController();

// ignore: prefer_typing_uninitialized_variables
var downloadUrl;

//  progressBar for visibility
bool _loading = false;

// bool for textfield error
bool _productNameError = false;
bool _productPriceError = false;

// uid of user
final uid = FirebaseAuth.instance.currentUser!.uid;

class _SellerHomeScreen extends State<SellerHomeScreen> {
  File? _image;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: RefreshIndicator(
            strokeWidth: 3,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "Your Product",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    itemCount: SellerHomeScreen.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Container(
                          height: 500,
                          child: Card(
                            semanticContainer: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        SellerHomeScreen.products[index]
                                            .get('product_image'),
                                        fit: BoxFit.fill,
                                      ),
                                    )),
                                    Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Text(
                                                SellerHomeScreen.products[index]
                                                    .get('product_name'),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .currency_rupee_rounded,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      SellerHomeScreen
                                                          .products[index]
                                                          .get('product_price'),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ))
                                  ],
                                )),
                          ));
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
            showModalBottomSheet(
                isDismissible: false,
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
                          return Scaffold(
                              backgroundColor: Colors.transparent,
                              floatingActionButton: Container(
                                width: 80,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        123, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(20)),
                                transform:
                                    Matrix4.translationValues(0.0, -15, 0.0),
                                child: const SizedBox(
                                  width: 80,
                                  height: 5,
                                ),
                              ),
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.centerTop,
                              body: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 221, 245, 228),
                                            Color.fromARGB(255, 180, 226, 194)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                  child: Stack(
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.4,
                                                child: Stack(
                                                  children: [
                                                    InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        onTap: () async {
                                                          final image =
                                                              await ImagePicker()
                                                                  .pickImage(
                                                                      source: ImageSource
                                                                          .gallery);

                                                          if (image == null)
                                                            return null;

                                                          final tempImage =
                                                              File(image.path);

                                                          setState(() {
                                                            _image = tempImage;
                                                            // _showCamera = false;
                                                          });
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: _image == null
                                                              ? Image.asset(
                                                                  "assets/images/fruit.png",
                                                                )
                                                              : Image.file(
                                                                  _image!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        )),
                                                    Visibility(
                                                        visible: _image != null
                                                            ? true
                                                            : false,
                                                        child: Positioned(
                                                            bottom: 10,
                                                            right: 5,
                                                            child:
                                                                AnimatedOpacity(
                                                                    opacity:
                                                                        _image !=
                                                                                null
                                                                            ? 1
                                                                            : 0,
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            10),
                                                                    child: Container(
                                                                        decoration: BoxDecoration(color: const Color.fromARGB(28, 0, 0, 0), borderRadius: BorderRadius.circular(50)),
                                                                        child: IconButton(
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                _image = null;
                                                                              });
                                                                            },
                                                                            icon: const Icon(
                                                                              Icons.close_rounded,
                                                                              size: 25,
                                                                            ))))))
                                                  ],
                                                )),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20, left: 30, right: 30),
                                              child: TextField(
                                                  controller:
                                                      _productNameController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "Name",
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 2)),
                                                  )),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20, left: 30, right: 30),
                                              child: TextField(
                                                controller:
                                                    _productPriceController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: const InputDecoration(
                                                    hintText: "Price",
                                                    prefixIcon: Icon(Icons
                                                        .currency_rupee_rounded),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 2))),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 30, right: 30, top: 10),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "NOTE: Add amount as per kg",
                                                style: TextStyle(
                                                    color: Colors.red[900]),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: const EdgeInsets.only(
                                                  top: 50,
                                                  left: 30,
                                                  right: 30,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      _loading = true;
                                                    });
                                                    final uid = FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid;
                                                    if (_image != null &&
                                                        _productNameController
                                                            .text.isNotEmpty &&
                                                        _productPriceController
                                                            .text.isNotEmpty) {
                                                      var uuid = Uuid().v1();
                                                      Reference ref =
                                                          FirebaseStorage
                                                              .instance
                                                              .ref()
                                                              .child("images")
                                                              .child(uid)
                                                              .child(
                                                                  "products_image")
                                                              .child(uuid);
                                                      UploadTask uploadTask =
                                                          ref.putFile(_image!);
                                                      await uploadTask
                                                          .whenComplete(
                                                              () async {
                                                        downloadUrl = await ref
                                                            .getDownloadURL();
                                                      });

                                                      Map<String, String>
                                                          addProductObject = {
                                                        'product_image':
                                                            downloadUrl
                                                                .toString(),
                                                        'product_name':
                                                            _productNameController
                                                                .text,
                                                        'product_price':
                                                            _productPriceController
                                                                .text,
                                                        'product_id':
                                                            uuid.toString(),
                                                        'seller_id': uid
                                                      };

                                                      FirebaseFirestore.instance
                                                          .collection("Sellers")
                                                          .doc(uid)
                                                          .collection(
                                                              "products")
                                                          .doc(Uuid().v4())
                                                          .set(addProductObject)
                                                          .whenComplete(() {
                                                        final snackBar =
                                                            SnackBar(
                                                          content: Text(
                                                              "Product successfully added"),
                                                          // key: _scaffoldKey,
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                        setState(() {
                                                          _loading = false;
                                                          _image = null;
                                                        });
                                                        _productNameController
                                                            .text = "";
                                                        _productPriceController
                                                            .text = "";
                                                        _getProducts();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _loading = false;
                                                      });
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            "Add a proper data"),
                                                        backgroundColor: Colors
                                                            .redAccent[500],
                                                        // key: _scaffoldKey,
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Add",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                          visible: _loading,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            child:
                                                const CircularProgressIndicator(),
                                          ))
                                    ],
                                  )));
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

  _getProducts() async {
    SellerHomeScreen.products.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Sellers')
        .doc(uid)
        .collection('products')
        .get();

    setState(() {
      SellerHomeScreen.products.addAll(querySnapshot.docs);
    });
  }
}
