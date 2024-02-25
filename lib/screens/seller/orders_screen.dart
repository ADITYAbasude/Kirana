import 'package:Kirana/screens/seller/manage_order_screen.dart';
import 'package:Kirana/utils/get_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../utils/screen_route_translation.dart';
import '../../widget/order_card_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    _getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Manage Orders'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
            child: orders.isNotEmpty
                ? ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                screenRouteTranslation(ManageOrderScreen(
                                    orders[index]['order_id'])));
                          },
                          child: OrderCardWidget(orders[index]));
                    })
                : Center(
                    child: Text("No Orders Yet"),
                  )));
  }

  _getAllOrders() async {
    orders.clear();
    await FirebaseDatabase.instance
        .ref('sellers/$uid/orders')
        .get()
        .then((value) {
      if (value.exists) {
        for (var order in value.children) {
          setState(() {
            orders.add(order.value);
          });
        }
      }
    });
  }
}
