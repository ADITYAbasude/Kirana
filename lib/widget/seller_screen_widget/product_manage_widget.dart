// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/seller/seller_home_screen.dart';
import 'package:grocery_app/tools/Toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../screens/seller/seller_product_detailed_screen.dart';

class ProductManageWidget extends StatefulWidget {
  const ProductManageWidget({Key? key}) : super(key: key);
  static String product_manage_status = '';
  static bool product_img_editing = false;
  @override
  _ProductManageWidgetState createState() => _ProductManageWidgetState();
}

// ignore: prefer_typing_uninitialized_variables
var downloadUrl;

// textfield controllers
final _productNameController = TextEditingController();
final _productPriceController = TextEditingController();
final _productStockController = TextEditingController();
final _productDescriptionController = TextEditingController();

// lists
List<String> units = ["/ 500 g", "/ 1 pc"];

// default data variables
String unitsCriteriaData = "/ 500 g";

//  progressBar for visibility
bool _loading = false;

class _ProductManageWidgetState extends State<ProductManageWidget> {
  var _image;

  @override
  void initState() {
    super.initState();
    _productStockController.text = "0";

    //set product value if it will in product editing
    if (ProductManageWidget.product_manage_status == "edit") {
      _productNameController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]
          .get('product_name');

      _productPriceController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]
          .get('product_price');

      _productDescriptionController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]
          .get('product_description');

      _productStockController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]
          .get('product_stock');

      _image = SellerHomeScreen.products[SellerProductDetailedScreen.index!]
          .get('product_image');
    }
    // _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    String _unitsTypeValue = units.first;

    var size = MediaQuery.of(context).size;
    int ScreenWidth = size.width.toInt() - 70;

    void create_or_edit_the_product() async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      if (_image != null &&
          _productNameController.text.isNotEmpty &&
          _productPriceController.text.isNotEmpty &&
          _productDescriptionController.text.isNotEmpty &&
          _productStockController.text.isNotEmpty) {
        var uuid = ProductManageWidget.product_manage_status == "edit"
            ? SellerHomeScreen.products[SellerProductDetailedScreen.index!]
                .get('product_id')
            : Uuid().v1();

        if (ProductManageWidget.product_img_editing == true) {
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("images")
              .child(uid)
              .child("products_image")
              .child(uuid);
          UploadTask uploadTask = ref.putFile(_image!);
          await uploadTask.whenComplete(() async {
            downloadUrl = await ref.getDownloadURL();
          });
        }

        Map<String, String> addProductObject = {
          'product_image': ProductManageWidget.product_img_editing == true
              ? downloadUrl.toString()
              : _image,
          'product_name': _productNameController.text,
          'product_description': _productDescriptionController.text,
          'product_stock': _productStockController.text,
          'product_price': _productPriceController.text,
          'product_unit': unitsCriteriaData,
          'product_id': uuid.toString(),
          'seller_id': uid
        };

        FirebaseFirestore.instance
            .collection("Sellers")
            .doc(uid)
            .collection("products")
            .doc(uuid)
            .set(addProductObject)
            .whenComplete(() {
          const snackBar = SnackBar(
            content: Text("Product successfully added"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _loading = false;
            _image = null;
          });
          _productNameController.text = "";
          _productPriceController.text = "";
          _productDescriptionController.text = "";
          _productStockController.text = "0";
          //  _getProducts();
        });
      } else {
        setState(() {
          _loading = false;
        });
        final snackBar = SnackBar(
          content: const Text("Add a proper data"),
          backgroundColor: Colors.redAccent[500],
          // key: _scaffoldKey,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Container(
          width: 80,
          height: 5,
          decoration: BoxDecoration(
              color: const Color.fromARGB(123, 255, 255, 255),
              borderRadius: BorderRadius.circular(20)),
          transform: Matrix4.translationValues(0.0, -15, 0.0),
          child: const SizedBox(
            width: 80,
            height: 5,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 221, 245, 228),
                  Color.fromARGB(255, 180, 226, 194)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Stack(
              children: [
                ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: Stack(
                          children: [
                            InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  final image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery)
                                      .then((value) {
                                    if (value != null) {
                                      // &&
                                      //     ProductManageWidget
                                      //             .product_manage_status ==
                                      //         "edit") {
                                      ProductManageWidget.product_img_editing =
                                          true;
                                      setState(() {
                                        _image = File(value.path);
                                      });
                                    }
                                  });

                                  // if (image == null) return null;

                                  // final tempImage = File(image.path);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _image == null
                                      ? Image.asset(
                                          "assets/images/fruit.png",
                                          fit: BoxFit.cover,
                                          width: 250,
                                          height: 200,
                                        )
                                      : ProductManageWidget
                                                  .product_manage_status ==
                                              "add"
                                          ? Image.file(
                                              _image!,
                                              fit: BoxFit.cover,
                                              width: 250,
                                              height: 200,
                                            )
                                          : ProductManageWidget
                                                      .product_img_editing ==
                                                  true
                                              ? Image.file(
                                                  _image,
                                                  fit: BoxFit.cover,
                                                  width: 250,
                                                  height: 200,
                                                )
                                              : Image.network(
                                                  _image,
                                                  fit: BoxFit.cover,
                                                  width: 250,
                                                  height: 200,
                                                ),
                                )),
                            Visibility(
                                visible: _image != null ? true : false,
                                child: Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: AnimatedOpacity(
                                        opacity: _image != null ? 1 : 0,
                                        duration: const Duration(seconds: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    28, 0, 0, 0),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
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

                    //divider
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: const Divider(
                        color: Colors.black45,
                      ),
                    ),

                    // product name
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 30, right: 30),
                      child: TextField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2)),
                          )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          children: [
                            // price od product
                            SizedBox(
                              width: ScreenWidth / 2,
                              child: TextField(
                                controller: _productPriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Price",
                                    prefixIcon:
                                        Icon(Icons.currency_rupee_rounded),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2))),
                              ),
                            ),

                            // unit of product
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: ScreenWidth / 2,
                              child: DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Units")),
                                  value: _unitsTypeValue,
                                  onChanged: (value) {
                                    unitsCriteriaData = value.toString();
                                  },
                                  items: units.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()),
                            )
                          ],
                        )),
                    // product description
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: TextField(
                        maxLines: 5,
                        controller: _productDescriptionController,
                        decoration: const InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2))),
                      ),
                    ),

                    // textfield for quantity of product
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: _productStockController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Stock",
                              helperText: unitsCriteriaData == "/ 500 g"
                                  ? "${(int.parse(_productStockController.text) / 1000).toString()} kg"
                                  : "${_productStockController.text} pc",
                              suffixText: unitsCriteriaData == "/ 500 g"
                                  ? "gram"
                                  : "pc",
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2))),
                        )),

                    // add button is here with db functions
                    Container(
                      width: ScreenWidth.toDouble(),
                      margin: const EdgeInsets.only(
                          top: 50, left: 30, right: 30, bottom: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            create_or_edit_the_product();
                          },
                          child: Text(
                            ProductManageWidget.product_manage_status == "add"
                                ? "Add"
                                : "Edit",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),

                // loading weight
                Visibility(
                    visible: _loading,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ))
              ],
            )));
  }

  @override
  void dispose() {
    _productNameController.text = "";
    _productDescriptionController.text = "";
    _productStockController.text = "";
    _productPriceController.text = "";
    ProductManageWidget.product_img_editing = false;

    super.dispose();
  }
}
