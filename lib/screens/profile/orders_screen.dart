import 'package:Kirana/utils/screen_route_translation.dart';
import 'package:Kirana/widget/order_card_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../constants/SystemColors.dart';
import '../../utils/get_info.dart';
import 'order_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static List orderList = [];

  final DatabaseReference _userOrdersRef =
      FirebaseDatabase.instance.ref('users/$uid/order');
  @override
  void initState() {
    _getUserOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Orders",
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
        ),
        body: Container(
            child: orderList.isNotEmpty
                ? ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                screenRouteTranslation(OrderDetailScreen(
                                    orderList[index]['order_id'])));
                          },
                          child: OrderCardWidget(orderList[index]));
                    })
                : Center(
                    child: Text("No Orders Yet"),
                  )));
  }

  _getUserOrders() async {
    orderList.clear();
    await _userOrdersRef.get().then((value) {
      for (var data in value.children) {
        setState(() {
          orderList.add(data.value);
        });
      }
      setState(() {
        orderList = orderList.reversed.toList();
      });
    });
  }
}
