import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/constants/SystemColors.dart';
import 'package:grocery_app/tools/Toast.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/user_info.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => gallery();
}

var _image;

//text controllers
final _userNameController = TextEditingController();
final _phoneNumberController = TextEditingController();

class gallery extends State<MyProfileScreen> {
  Future<dynamic> username = UserData.userName(uid);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenLightMode,
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text(
          "My Profile",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: _image == null
                          ? Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(100)),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                _image,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                            )),
                  Positioned(
                      bottom: 5,
                      right: 0,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          )))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "User Name",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: _userNameController,
                    style: const TextStyle(height: 1),
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      hintText: "",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(height: 1),
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      hintText: "",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(mainColor)),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.save_alt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  label: Text(
                    "Save",
                    style: TextStyle(color: textColor, fontSize: 17),
                  )),
            )
          ],
        ),
      ),
    );
  }

/* pickImage function is crucial, because this function takes an
   image from user gallery on user request. */
  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final tempImage = File(image.path);

    setState(() {
      _image = tempImage;
    });
  }
}
