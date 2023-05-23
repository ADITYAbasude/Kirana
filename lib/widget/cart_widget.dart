import 'package:Kirana/utils/screen_route_translation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/utils/get_info.dart';

import '../constants/ConstantValue.dart';
import '../screens/home/product_detail_screen.dart';

class CartWidget extends StatefulWidget {
  final cart;
  final Function removeProductFromCartListCallback;
  final int index;
  final Function updateSubTotalPriceCallback;
  final Function updateProductQuantityCallback;
  const CartWidget(
      this.cart,
      this.removeProductFromCartListCallback,
      this.index,
      this.updateSubTotalPriceCallback,
      this.updateProductQuantityCallback);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  var productinfo;
  String unit = "";
  int productQuantity = 1;
  @override
  void initState() {
    super.initState();
    _getProductInfo();
    productQuantity = widget.cart['product_quantity'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, screenRouteTranslation(ProductDetailScreen(productinfo)));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0,
                  color: Color.fromARGB(78, 0, 0, 0),
                  offset: Offset(0, 0))
            ]),
        width: getScreenSize(context).width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: productinfo != null
                    ? Image.network(
                        productinfo['product_image'],
                        width: 100,
                        fit: BoxFit.fitHeight,
                      )
                    : Image.asset('assets/images/fruit.png'),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (getScreenSize(context).width / 2) - 70,
                          child: Text(
                            productinfo != null
                                ? productinfo['product_name']
                                : "",
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 17,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _removeProductFromCart();
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productinfo != null ? unit : "",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Text(
                                  productinfo != null
                                      ? '₹ ${productinfo['product_price']}'
                                      : '₹ 0',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: productQuantity != 1
                                ? () {
                                    if (productQuantity > 1) {
                                      setState(() {
                                        productQuantity--;
                                      });
                                      _updateProductQuantity();
                                    }
                                  }
                                : null,
                            icon: const Icon(
                              Icons.remove_rounded,
                              size: 16,
                            )),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: const Border.fromBorderSide(BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1)))),
                            child: Text(productQuantity.toString())),
                        IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                productQuantity++;
                              });
                              _updateProductQuantity();
                            },
                            icon: const Icon(
                              Icons.add_rounded,
                              size: 16,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getProductInfo() async {
    await FirebaseDatabase.instance
        .ref(
            'sellers/${widget.cart['seller_id']}/products/${widget.cart['product_id']}/info')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          productinfo = value.value as Map;
          widget.updateSubTotalPriceCallback(
              double.parse(productinfo['product_price'].toString()),
              widget.index);
          if (productinfo['product_unit'] == '/ 1 pc') {
            unit = '1 pc';
          } else {
            unit = '500gr';
          }
        });
      }
    });
  }

  void _updateProductQuantity() async {
    await FirebaseDatabase.instance
        .ref('users/${uid}/cart/${widget.cart['product_id']}')
        .update({'product_quantity': productQuantity}).then((value) {
      widget.updateProductQuantityCallback(productQuantity, widget.index);
    });
  }

  void _removeProductFromCart() async {
    await FirebaseDatabase.instance
        .ref('users/${uid}/cart/${widget.cart['product_id']}')
        .remove()
        .then((value) {
      print(widget.index);
      widget.removeProductFromCartListCallback(widget.index);
    });
  }
}
