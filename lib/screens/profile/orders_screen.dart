import 'package:Kirana/widget/order_card_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../constants/SystemColors.dart';
import '../../utils/get_info.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static List orderList = [];

  DatabaseReference _userOrdersRef =
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
                      return OrderCardWidget(orderList[index]);
                    })
                : Center(
                    child: Text("No Orders Yet"),
                  )));
  }

  _getUserOrders() async {
    await _userOrdersRef.get().then((value) {
      for (var data in value.children) {
        setState(() {
          orderList.add(data.value);
        });
      }
    });
  }
}
