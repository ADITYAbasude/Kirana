import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../constants/ConstantValue.dart';
import '../../constants/SystemColors.dart';
import '../../tools/loading.dart';
import '../../widget/product_card_widget.dart';

class CategoriesScreen extends StatefulWidget {
  String categoryType;
  CategoriesScreen(this.categoryType);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List products = [];
  bool _loading = false;

  @override
  initState() {
    _findProductsByCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double itemWidth = getScreenSize(context).width / 1.9;
    final double itemHeight =
        (getScreenSize(context).height - kToolbarHeight - 24) / 2.6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            widget.categoryType,
            style: const TextStyle(
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
        body: Stack(
          children: [
            Container(
                child: GridView.builder(
                    padding: const EdgeInsets.all(5),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: itemWidth / itemHeight),
                    itemBuilder: (context, index) {
                      return ProductCardWidget(products[index]);
                    })),
            Visibility(
                visible: _loading,
                child: Center(
                  child: Loading(),
                ))
          ],
        ));
  }

  _findProductsByCategory() async {
    products.clear();
    _loading = true;
    await FirebaseDatabase.instance.ref('sellers').get().then((value) {
      for (var stores in value.children) {
        stores.ref.child('products').get().then((value) {
          for (var product in value.children) {
            product.ref.child('info').get().then((value) {
              var productData = value.value as Map;
              if (productData['product_criteria'] == widget.categoryType) {
                setState(() {
                  products.add(productData);
                });
              }
            });
          }
        });
      }
      setState(() {
        _loading = false;
      });
    }).whenComplete(() {
      products.shuffle();
      _loading = false;
    }).onError((error, stackTrace) {
      _loading = false;
    });
  }
}
