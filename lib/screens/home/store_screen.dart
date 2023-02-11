import 'package:flutter/material.dart';
import 'package:grocery_app/constants/ConstantValue.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen(this.shopData);
  var shopData;

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromARGB(73, 0, 0, 0),
      ),
      body: Container(
        child: ListView(
          children: [
            Image.network(
              widget.shopData['shop_image'],
              width: double.infinity,
              height: getScreenSize(context).height / 4,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
