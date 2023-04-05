import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/constants/ConstantValue.dart';
import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/widget/store_products_cart_widget.dart';

import '../../widget/product_card_widget.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen(this.shopData);
  var shopData;

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List _showProducts = [];

  @override
  void initState() {
    _getShopProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.shopData['shop_name'],
          style: TextStyle(
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: mainColor,
      ),
      body: Container(
        height: getScreenSize(context).height,
        child: ListView(
          children: [
            Image.network(
              widget.shopData['shop_image'],
              fit: BoxFit.fill,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Text(
                widget.shopData['shop_address'],
                maxLines: 1,
                softWrap: true,
                style: TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis),
              ),
            ),
            Container(
              // height: 500,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _showProducts.length,
                itemBuilder: (context, index) {
                  return StoreProductsCartWidget(_showProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getShopProducts() async {
    await FirebaseDatabase.instance
        .ref('sellers/${widget.shopData['seller_id']}/products')
        .get()
        .then((value) async {
      for (var productData in value.children) {
        await productData.ref.child('info').get().then((value) {
          setState(() {
            _showProducts.add(value.value);
          });
        });
      }
    });
  }
}
