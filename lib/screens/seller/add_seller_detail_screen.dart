// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_final_fields, deprecated_member_use, import_of_legacy_library_into_null_safe

/* 
This file is created by Aditya
copyright year 2022
*/
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:grocery_app/constants/SystemColors.dart';
// import 'package:grocery_app/constants/geo_locator.dart';
import 'package:grocery_app/screens/main_screen.dart';
import 'package:grocery_app/tools/SnackBar.dart';
import 'package:grocery_app/tools/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSellerDetailScreen extends StatefulWidget {
  AddSellerDetailScreen({Key? key}) : super(key: key);

  @override
  State<AddSellerDetailScreen> createState() => _AddSellerDetailScreenState();
}

const List<String> _storeTypeList = <String>['Vegetable', 'Fruit', 'Juice'];
bool _check = false;
bool _showProgressBar = false;

// textfield controllers
final _shopNameController = TextEditingController();
final _shopAddressController = TextEditingController();
final _shopContactNumberController = TextEditingController();

// bool for check that data is validate or not
bool _errorForShopName = false;
bool _errorForShopAddress = false;
bool _errorForShopContactNumber = false;

String? shopNameData;
String? shopAddressData;
String? shopContactNumberData;
// String shopCriteriaData = "Vegetable";

// storage ref
FirebaseStorage? fStorage;
var downloadUrl;

//db ref
DatabaseReference _dbRef = FirebaseDatabase.instance.ref('sellers');

class _AddSellerDetailScreenState extends State<AddSellerDetailScreen> {
  String _storeTypeValue = _storeTypeList.first;

// it will store the selected image by user
  File? _image;

// set bool
  bool _showCamera = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text("Seller detail",
              style: TextStyle(color: Colors.white)),
          elevation: 2,
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              )),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(
                    androidOverscrollIndicator:
                        AndroidOverscrollIndicator.stretch),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          width: double.infinity,
                          child: Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _pickImage();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    elevation: 0,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: _image == null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: const Image(
                                                    fit: BoxFit.cover,
                                                    image: CachedNetworkImageProvider(
                                                        "https://raw.githubusercontent.com/ADITYAbasude/Shopify/master/frontend/src/components/data/img/user.png")))
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.file(
                                                  _image!,
                                                  fit: BoxFit.cover,
                                                )),
                                      ),
                                      Visibility(
                                          visible: _showCamera,
                                          child: Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Color.fromARGB(
                                                          255, 255, 255, 255)
                                                      .withOpacity(0.8),
                                                ),
                                              )))
                                    ],
                                  )),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 20, top: 10),
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextField(
                                  controller: _shopNameController,
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                    errorText: _errorForShopName
                                        ? "Name length should be min 4 letters or above"
                                        : null,
                                    hintText: "Shop name",
                                    // ignore: prefer_const_constructors
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2)),
                                    errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 173, 28, 15),
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2)),
                                    enabledBorder: const OutlineInputBorder(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            height: 1,
                            child: const Divider()),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: TextField(
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLines: 2,
                            minLines: 1,
                            controller: _shopAddressController,
                            decoration: InputDecoration(
                              hintText: "Shop address",
                              errorText: _errorForShopAddress
                                  ? "Add your shop address"
                                  : null,
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 173, 28, 15),
                                      width: 2)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)),
                              prefixIcon: const Icon(Icons.location_on_rounded),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)),
                              enabledBorder: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: TextField(
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLines: 2,
                            minLines: 1,
                            maxLength: 10,
                            controller: _shopContactNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorText: _errorForShopContactNumber
                                  ? "Enter a proper contact number"
                                  : null,
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 173, 28, 15),
                                      width: 2)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)),
                              prefixText: "91 | ",
                              hintText: "Shop contact number",
                              prefixIcon: const Icon(Icons.call_rounded),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)),
                              enabledBorder: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //       top: 20, left: 20, right: 20),
                        //   width: double.infinity,
                        //   child: DropdownButtonFormField(
                        //       decoration: const InputDecoration(
                        //           border: OutlineInputBorder(),
                        //           label: Text("Shop criteria")),
                        //       value: _storeTypeValue,
                        //       onChanged: (value) {
                        //         shopCriteriaData = value.toString();
                        //       },
                        //       items: _storeTypeList
                        //           .map<DropdownMenuItem<String>>(
                        //               (String value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: Text(value),
                        //         );
                        //       }).toList()),
                        // ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 20),
                          child: Row(
                            children: [
                              Checkbox(
                                  tristate: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  value: _check,
                                  splashRadius: 10,
                                  onChanged: ((value) {
                                    setState(() {
                                      _check = !_check;
                                    });
                                  })),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _check = !_check;
                                    });
                                  },
                                  child: const Text(
                                      "Above the given data is right")),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                        width: double.infinity,
                        height: 40,
                        margin:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: ElevatedButton(
                          onPressed: _check
                              ? () {
                                  _validateTheData();
                                  _saveDataInDB();
                                }
                              : null,
                          child: const Text("Continue",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ))
                  ],
                )),
              ),
            ),
            Visibility(
                visible: _showProgressBar,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Loading(),
                ))
          ],
        ));
  }

  void _validateTheData() {
    shopNameData = _shopNameController.text;
    shopAddressData = _shopAddressController.text;
    shopContactNumberData = _shopContactNumberController.text;

    if (shopNameData!.length < 3) {
      setState(() {
        _errorForShopName = true;
      });
    } else {
      setState(() {
        _errorForShopName = false;
      });
    }

    if (shopAddressData!.isEmpty) {
      setState(() {
        _errorForShopAddress = true;
      });
    } else {
      setState(() {
        _errorForShopAddress = false;
      });
    }

    if (shopContactNumberData!.length < 10) {
      setState(() {
        _errorForShopContactNumber = true;
      });
    } else {
      setState(() {
        _errorForShopContactNumber = false;
      });
    }
  }

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final tempImage = File(image.path);

    setState(() {
      _image = tempImage;
      _showCamera = false;
    });
  }

  void _saveDataInDB() async {
    if (_image == null) {
      showSnackBar(context, "Add store image", color: Colors.red[700] as Color);
    } else if (!_errorForShopAddress &&
        !_errorForShopContactNumber &&
        !_errorForShopName &&
        _image != null) {
      _showProgressBar = true;

      // user uid
      final uid = FirebaseAuth.instance.currentUser!.uid;
      fStorage = FirebaseStorage.instance;

      // convert address in latlng
      var coordinate = await Geocoder.local
          .findAddressesFromQuery(_shopAddressController.text);

      // it's a database reference
      Reference ref =
          fStorage!.ref().child("images").child(uid).child("seller_image");
      UploadTask uploadTask = ref.putFile(_image!);
      await uploadTask.whenComplete(() async {
        downloadUrl = await ref.getDownloadURL(); // here we get an url of image
      });

      var userNameData =
          await FirebaseDatabase.instance.ref('users/$uid/info').get();

      var username = userNameData.value as Map;

      Map<String, String> dataObject = {
        'shop_image': downloadUrl.toString(),
        'shop_name': shopNameData.toString(),
        'shop_address': shopAddressData.toString(),
        'shop_contact_number': shopContactNumberData.toString(),
        'seller_id': uid,
        "seller_name": username['name'],
        'lat': coordinate[0].coordinates.latitude.toString(),
        'lng': coordinate[0].coordinates.longitude.toString()
      };

      _dbRef.child('$uid/info').set(dataObject).whenComplete(() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('seller', "seller");
        setState(() {
          _showProgressBar = false;
        });
        Navigator.pop(context);
        MainScreen.itemIndex = 3;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      });
    }
  }
}
