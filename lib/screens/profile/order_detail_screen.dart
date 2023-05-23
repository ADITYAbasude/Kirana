import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/tools/Toast.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/get_info.dart';

class OrderDetailScreen extends StatefulWidget {
  final orderId;
  const OrderDetailScreen(this.orderId);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  var orderInfo;
  var productInfo;

  @override
  void initState() {
    super.initState();
    _getOrderInfo();
  }

  late DateTime date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: mainColor,
          // backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green.shade100),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: productInfo != null
                          ? Image.network(
                              productInfo['product_image'],
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/icons/order.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            orderInfo != null
                                ? 'Order #' + orderInfo['order_id']
                                : '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              productInfo != null
                                  ? 'Placed on${DateFormat(" MMMM dd yyyy , h:m").format(date)}'
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  productInfo != null
                                      ? 'Quantity ${orderInfo['product_quantity']}'
                                      : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  productInfo != null
                                      ? 'Price ₹${orderInfo['product_price']}'
                                      : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  _getOrderInfo() async {
    await FirebaseDatabase.instance
        .ref('users/$uid/order/${widget.orderId}')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          orderInfo = value.value as Map;
          date = DateTime.fromMillisecondsSinceEpoch(
              int.parse(orderInfo['order_date'].toString()));
        });
        _getProductInfo();
      }
    });
  }

  _getProductInfo() async {
    await FirebaseDatabase.instance
        .ref(
            'sellers/${orderInfo['seller_id']}/products/${orderInfo['product_id']}/info')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          productInfo = value.value as Map;
        });
      }
    });
  }
}
