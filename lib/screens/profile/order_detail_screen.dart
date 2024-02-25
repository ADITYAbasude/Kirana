import 'package:Kirana/utils/screen_size.dart';
import 'package:Kirana/constants/SystemColors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

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

  String orderStatus = 'Pending';

  List orderStatusList = [
    'Pending',
    'Accepted',
    'Packed',
    'Shipped',
    'Delivered',
  ];

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
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
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
                              vertical: 5, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Arriving on ${orderInfo != null ? orderInfo['order_date'].compareTo(DateTime.now().toString()) == 0 ? 'Toady' : DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderInfo['order_date'].toString()))) : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: getScreenSize(context).width,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: orderInfo != null && productInfo != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Product : ' + productInfo['product_name']),
                        Text('Quantity : ' +
                            orderInfo['product_quantity'].toString()),
                        Text('Price : ₹' +
                            orderInfo['product_price'].toString()),
                        Text('Address : ' + orderInfo['customer_address']),
                        Text(date != null
                            ? 'Order placed on ${DateFormat(" MMMM dd yyyy , h:m").format(date)}'
                            : ''),
                        Text(
                            'Order Id : ${orderInfo != null ? orderInfo['order_id'] : ''}'),
                      ],
                    )
                  : Text(''),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: true,
                    afterLineStyle: 1 <= orderStatusList.indexOf(orderStatus)
                        ? LineStyle(thickness: 4, color: Colors.green)
                        : LineStyle(thickness: 3, color: Colors.grey),
                    indicatorStyle: IndicatorStyle(
                        width:
                            1 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        height:
                            1 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        padding: EdgeInsets.all(5),
                        indicator: 1 <= orderStatusList.indexOf(orderStatus)
                            ? Container(
                                padding: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Center(
                                    child: Image.asset(
                                        'assets/icons/done-with-animated.gif')),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              )),
                    endChild: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              1 <= orderStatusList.indexOf(orderStatus)
                                  ? 'Order confirmed'
                                  : 'Order confirmation',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          1 <= orderStatusList.indexOf(orderStatus)
                              ? const Text(
                                  '',
                                  style: TextStyle(fontSize: 0),
                                )
                              : Text(
                                  'Waiting from seller site to accept the order'),
                          // Text(
                          //     'Order placed on ${DateFormat(" MMMM dd yyyy , h:m").format(date)}'),
                        ],
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    hasIndicator: true,
                    afterLineStyle: 2 <= orderStatusList.indexOf(orderStatus)
                        ? LineStyle(thickness: 4, color: Colors.green)
                        : LineStyle(thickness: 3, color: Colors.grey),
                    beforeLineStyle: 2 <= orderStatusList.indexOf(orderStatus)
                        ? LineStyle(thickness: 4, color: Colors.green)
                        : LineStyle(thickness: 3, color: Colors.grey),
                    indicatorStyle: IndicatorStyle(
                        width:
                            2 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        height:
                            2 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        padding: EdgeInsets.all(5),
                        indicator: 2 <= orderStatusList.indexOf(orderStatus)
                            ? Container(
                                padding: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Center(
                                    child: Image.asset(
                                        'assets/icons/done-with-animated.gif')),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              )),
                    endChild: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              2 <= orderStatusList.indexOf(orderStatus)
                                  ? 'Order packed'
                                  : 'Order packaging',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          2 <= orderStatusList.indexOf(orderStatus)
                              ? const Text(
                                  '',
                                  style: TextStyle(fontSize: 0),
                                )
                              : Text('Your order is being packed'),
                          // Text(
                          //     'Order placed on ${DateFormat(" MMMM dd yyyy , h:m").format(date)}'),
                        ],
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    hasIndicator: true,
                    afterLineStyle: 3 <= orderStatusList.indexOf(orderStatus)
                        ? LineStyle(thickness: 4, color: Colors.green)
                        : LineStyle(thickness: 3, color: Colors.grey),
                    beforeLineStyle: 3 <= orderStatusList.indexOf(orderStatus)
                        ? LineStyle(thickness: 4, color: Colors.green)
                        : LineStyle(thickness: 3, color: Colors.grey),
                    indicatorStyle: IndicatorStyle(
                        width:
                            3 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        height:
                            3 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        padding: EdgeInsets.all(5),
                        indicator: 3 <= orderStatusList.indexOf(orderStatus)
                            ? Container(
                                padding: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Center(
                                    child: Image.asset(
                                        'assets/icons/done-with-animated.gif')),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              )),
                    lineXY: 0.1,
                    // isLast: true,
                    endChild: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Out for delivery',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Your order is on the way'),
                          // Text(
                          //     'Order placed on ${DateFormat(" MMMM dd yyyy , h:m").format(date)}'),
                        ],
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    hasIndicator: true,
                    afterLineStyle: 4 <= orderStatusList.indexOf(orderStatus)
                        ? LineStyle(thickness: 4, color: Colors.green)
                        : LineStyle(thickness: 3, color: Colors.grey),
                    beforeLineStyle: 4 <= orderStatusList.indexOf(orderStatus)
                        ? LineStyle(thickness: 4, color: Colors.green)
                        : LineStyle(thickness: 3, color: Colors.grey),
                    indicatorStyle: IndicatorStyle(
                        width:
                            4 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        height:
                            4 <= orderStatusList.indexOf(orderStatus) ? 30 : 20,
                        padding: EdgeInsets.all(5),
                        indicator: 4 <= orderStatusList.indexOf(orderStatus)
                            ? Container(
                                padding: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Center(
                                    child: Image.asset(
                                        'assets/icons/done-with-animated.gif')),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              )),
                    lineXY: 0.1,
                    isLast: true,
                    endChild: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delivered',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Your order is delivered'),
                          // Text(
                          //     'Order placed on ${DateFormat(" MMMM dd yyyy , h:m").format(date)}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery guy detail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        )));
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
          orderStatus = orderInfo['order_status'] ?? 'Pending';
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
