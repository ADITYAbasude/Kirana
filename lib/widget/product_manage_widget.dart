// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_field

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/seller/seller_home_screen.dart';
import 'package:Kirana/tools/SnackBar.dart';
import 'package:Kirana/tools/loading.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/seller/seller_product_detailed_screen.dart';

class ProductManageWidget extends StatefulWidget {
  ProductManageWidget(this.controller);
  final controller;
  static String product_manage_status = '';
  static bool product_img_editing = false;
  @override
  _ProductManageWidgetState createState() => _ProductManageWidgetState();
}

final List<String> _productTypeList = [
  'Vegetable',
  'Fruit',
  'Beverage',
  'Household',
  'Dairy',
  'Snack'
];
// lists
List<String> units = ["/ 500 g", "/ 1 pc"];

class _ProductManageWidgetState extends State<ProductManageWidget> {
  var downloadUrl;
  String _productCriteria = "Vegetable";

// textfield controllers
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productStockController = TextEditingController();
  final _productDescriptionController = TextEditingController();

// default data variables
  String unitsCriteriaData = "/ 500 g";

// bool for progressBar visibility
  bool _loading = false;
  var _image;

  String _storeTypeValue = _productTypeList.first;

  String _unitsTypeValue = units.first;

  // total orders of specific product
  int _totalOrdersOfProduct = 0;

  @override
  void initState() {
    super.initState();
    _productStockController.text = "0";

    //set product value if it will in product editing
    if (ProductManageWidget.product_manage_status == "edit") {
      _productNameController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]['product_name'];

      _productPriceController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]['product_price']
          .toString();

      _productDescriptionController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]['product_description'];

      _productStockController.text = SellerHomeScreen
          .products[SellerProductDetailedScreen.index!]['product_stock']
          .toString();

      _image = SellerHomeScreen.products[SellerProductDetailedScreen.index!]
          ['product_image'];

      setState(() {
        _productCriteria = SellerHomeScreen
            .products[SellerProductDetailedScreen.index!]['product_criteria'];

        unitsCriteriaData = SellerHomeScreen
            .products[SellerProductDetailedScreen.index!]['product_unit'];

        _unitsTypeValue =
            SellerHomeScreen.products[SellerProductDetailedScreen.index!]
                        ['product_unit'] ==
                    '/ 1 pc'
                ? units.last
                : units.first;

        _totalOrdersOfProduct = SellerHomeScreen
                .products[SellerProductDetailedScreen.index!]['total_orders'] ??
            0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int ScreenWidth = size.width.toInt() - 70;

    void create_or_edit_the_product() async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference pushKey =
          FirebaseDatabase.instance.ref('sellers').push();
      if (_image != null &&
          _productNameController.text.isNotEmpty &&
          _productPriceController.text.isNotEmpty &&
          _productDescriptionController.text.isNotEmpty &&
          _productStockController.text.isNotEmpty) {
        var pushId = ProductManageWidget.product_manage_status == "edit"
            ? SellerHomeScreen.products[SellerProductDetailedScreen.index!]
                ['product_id']
            : pushKey.key;

        if (ProductManageWidget.product_img_editing == true) {
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("images")
              .child(uid)
              .child("products_image")
              .child(pushId.toString());
          UploadTask uploadTask = ref.putFile(_image!);
          await uploadTask.whenComplete(() async {
            downloadUrl = await ref.getDownloadURL();
          });
        }

        Map<String, dynamic> addProductObject = {
          'product_image': ProductManageWidget.product_img_editing == true
              ? downloadUrl.toString()
              : _image,
          'product_name': _productNameController.text,
          'product_description': _productDescriptionController.text,
          'product_stock': int.parse(_productStockController.text),
          'product_price': int.parse(_productPriceController.text),
          'product_criteria': _productCriteria,
          'product_unit': unitsCriteriaData,
          'product_id': pushId,
          'seller_id': uid,
          'rating': ProductManageWidget.product_manage_status == "edit"
              ? SellerHomeScreen.products[SellerProductDetailedScreen.index!]
                  ['rating']
              : 0,
          'total_orders': _totalOrdersOfProduct
        };

        FirebaseDatabase.instance
            .ref('sellers')
            .child(uid)
            .child('products')
            .child(pushId)
            .child('info')
            .set(addProductObject)
            .whenComplete(() {
          setState(() {
            _loading = false;
            _image = null;
          });
          _productNameController.text = "";
          _productPriceController.text = "";
          _productDescriptionController.text = "";
          _productStockController.text = "0";
        });
      } else {
        setState(() {
          _loading = false;
        });
        showSnackBar(context, "Add a proper data",
            color: const Color.fromRGBO(255, 82, 82, 1));
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
            margin: const EdgeInsets.symmetric(horizontal: 5),
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
                  controller: widget.controller,
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
                                      ProductManageWidget.product_img_editing =
                                          true;
                                      setState(() {
                                        _image = File(value.path);
                                      });
                                    }
                                  });
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
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
                      margin:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      width: double.infinity,
                      child: DropdownButtonFormField(
                          dropdownColor: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Product criteria")),
                          value: _productCriteria,
                          onChanged: (value) {
                            setState(() {
                              _productCriteria = value.toString();
                            });
                          },
                          items: _productTypeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          children: [
                            // price of product
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
                              width: (ScreenWidth / 2) - 10,
                              child: DropdownButtonFormField(
                                  dropdownColor: Colors.green[100],
                                  borderRadius: BorderRadius.circular(10),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Units")),
                                  value: _unitsTypeValue,
                                  onChanged: (value) {
                                    setState(() {
                                      unitsCriteriaData = value.toString();
                                    });
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
                            style: const TextStyle(color: Colors.white),
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
                      child: Loading(),
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
