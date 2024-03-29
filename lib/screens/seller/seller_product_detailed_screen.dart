// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:Kirana/screens/seller/seller_home_screen.dart';
import '../../widget/product_manage_widget.dart';

class SellerProductDetailedScreen extends StatefulWidget {
  // final Function callBackFunction;
  const SellerProductDetailedScreen({super.key});
  static int? index;
  @override
  State<SellerProductDetailedScreen> createState() =>
      _SellerProductDetailedScreenState();
}

class _SellerProductDetailedScreenState
    extends State<SellerProductDetailedScreen> {
  final String _productDescription = SellerHomeScreen
      .products[SellerProductDetailedScreen.index!]['product_description'];

  String stock = SellerHomeScreen.products[SellerProductDetailedScreen.index!]
              ['product_unit'] ==
          '/ 500 g'
      ? (SellerHomeScreen.products[SellerProductDetailedScreen.index!]
                  ['product_stock'] /
              1000)
          .toString()
      : SellerHomeScreen.products[SellerProductDetailedScreen.index!]
              ['product_stock']
          .toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text("Product", style: TextStyle(color: Colors.white)),
        elevation: 2,
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => SellerHomeScreen()));
            }),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
      ),
      backgroundColor: Colors.white,
      body: ListView(children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ClipRRect(
                // borderRadius: BorderRadius.circular(50),
                child: Image.network(
              SellerHomeScreen.products[SellerProductDetailedScreen.index!]
                  ['product_image'],
              // width: 300,
              // height: 250,
              fit: BoxFit.cover,
            ))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  // product name text widget
                  SellerHomeScreen.products[SellerProductDetailedScreen.index!]
                      ['product_name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
                ),
              ),

              // product detailed description
              AnimatedContainer(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                duration: const Duration(seconds: 1),
                // height: 20,
                child: Text(
                  _productDescription,
                  style: const TextStyle(fontSize: 15, letterSpacing: 0),
                  textAlign: TextAlign.justify,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Price: ₹ ${SellerHomeScreen.products[SellerProductDetailedScreen.index!]['product_price']} ${SellerHomeScreen.products[SellerProductDetailedScreen.index!]['product_unit']}",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Stock: $stock ${SellerHomeScreen.products[SellerProductDetailedScreen.index!]['product_unit'] == '/ 500 g' ? ' kg' : ' pc'}",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const Divider(
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              ProductManageWidget.product_manage_status = "edit";
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
                            return ProductManageWidget(controller);
                          },
                        );
                      },
                    );
                  });
            },
            child: const Icon(Icons.edit_rounded),
          ),

          //? here, we not give a delete option to seller, if seller want to remove specific product then he/she can change the stock to 0

          // FloatingActionButton.small(
          //   heroTag: SellerProductDetailedScreen.index,
          //   onPressed: () {
          //     FirebaseDatabase.instance
          //         .ref(
          //             'sellers/$uid/products/${SellerHomeScreen.products[SellerProductDetailedScreen.index!]['product_id']}')
          //         .remove()
          //         .whenComplete(() {
          //       Navigator.pop(context);
          //     });
          //   },
          //   child: Icon(Icons.delete_outline),
          // )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  // color generator as seeing the product image

  // Future<PaletteGenerator> getColor() async {
  //   return await PaletteGenerator.fromImageProvider(Image.network(
  //           SellerHomeScreen.products[SellerProductDetailedScreen.index!]
  //               .get('product_image'))
  //       .image);
  // }
}
