// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSellerDetailScreen extends StatefulWidget {
  AddSellerDetailScreen({Key? key}) : super(key: key);

  @override
  State<AddSellerDetailScreen> createState() => _AddSellerDetailScreenState();
}

const List<String> _storeTypeList = <String>['Vegetable', 'Fruit', 'Juice'];
bool _check = false;

// textfield controllers
final _shopNameController = TextEditingController();
final _shopAddressController = TextEditingController();
final _shopContactNumberController = TextEditingController();

// bool for check that data is validate or not
bool _errorForShopName = false;
bool _errorForShopAddress = false;
bool _errorForShopContactNumber = false;

class _AddSellerDetailScreenState extends State<AddSellerDetailScreen> {
  String _storeTypeValue = _storeTypeList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Seller detail"),
          elevation: 2,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(
                androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                              Visibility(
                                  visible: true,
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: Positioned(
                                          child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black.withOpacity(0.5),
                                      ))))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
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
                                        color: Theme.of(context).primaryColor,
                                        width: 2)),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 173, 28, 15),
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
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
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      width: double.infinity,
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Shop criteria")),
                          value: _storeTypeValue,
                          onChanged: ((value) {}),
                          items: _storeTypeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                    ),
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
                          InkWell(
                              onTap: () {
                                setState(() {
                                  _check = !_check;
                                });
                              },
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child:
                                  const Text("Above the given data is right")),
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
                    margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: ElevatedButton(
                      onPressed: _check
                          ? () {
                              _validateTheData();
                            }
                          : null,
                      child: const Text("Continue"),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ))
              ],
            )),
          ),
        ));
  }

  void _validateTheData() {
    String shopNameData = _shopNameController.text;
    String shopAddressData = _shopAddressController.text;
    String shopContactNumberData = _shopContactNumberController.text;

    if (shopNameData.length < 3) {
      setState(() {
        _errorForShopName = true;
      });
    } else {
      setState(() {
        _errorForShopName = false;
      });
    }

    if (shopAddressData.isEmpty) {
      setState(() {
        _errorForShopAddress = true;
      });
    } else {
      setState(() {
        _errorForShopAddress = false;
      });
    }

    if (shopContactNumberData.length < 10) {
      setState(() {
        _errorForShopContactNumber = true;
      });
    } else {
      setState(() {
        _errorForShopContactNumber = false;
      });
    }
  }
}
