import 'package:Kirana/tools/Toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../constants/SystemColors.dart';
import '../../utils/get_info.dart';

class ManageOrderScreen extends StatefulWidget {
  final orderId;
  const ManageOrderScreen(this.orderId);

  @override
  _ManageOrderScreenState createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {
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
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                              productInfo != null
                                  ? productInfo['product_name']
                                  : '',
                              // maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      'Price: ${orderInfo != null ? orderInfo['product_price'] : ''}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      'Q: ${orderInfo != null ? orderInfo['product_quantity'] : ''}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
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
          ),
          if (orderInfo != null)
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
                      constraints: const BoxConstraints(
                        minHeight: 120,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              1 <= orderStatusList.indexOf(orderStatus)
                                  ? 'Order confirmed'
                                  : 'Order confirmation',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          1 <= orderStatusList.indexOf(orderStatus)
                              ? const Text(
                                  '',
                                  style: TextStyle(fontSize: 0),
                                )
                              : const Text('Waiting for your confirmation'),
                          Visibility(
                              visible: 1 <= orderStatusList.indexOf(orderStatus)
                                  ? false
                                  : true,
                              child: ElevatedButton(
                                  onPressed:
                                      1 <= orderStatusList.indexOf(orderStatus)
                                          ? null
                                          : () {
                                              _updateOrderStatus('Accepted');
                                            },
                                  child: Text('Next')))
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
                      // constraints: BoxConstraints(minHeight: 0, maxHeight: 50),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              1 <= orderStatusList.indexOf(orderStatus)
                                  ? 'Order packing'
                                  : 'Order packaged',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          2 <= orderStatusList.indexOf(orderStatus)
                              ? const Text(
                                  '',
                                  style: TextStyle(fontSize: 0),
                                )
                              : const Text('Pack the customer order'),
                          Visibility(
                              visible: 1 > orderStatusList.indexOf(orderStatus)
                                  ? false
                                  : true,
                              child: ElevatedButton(
                                  onPressed:
                                      2 <= orderStatusList.indexOf(orderStatus)
                                          ? null
                                          : () {
                                              _updateOrderStatus('Packed');
                                            },
                                  child: Text('Next')))
                        ],
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    hasIndicator: true,
                    beforeLineStyle: LineStyle(thickness: 3),
                    indicatorStyle: IndicatorStyle(
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(5),
                    ),
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
                        ],
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    hasIndicator: true,
                    beforeLineStyle: LineStyle(thickness: 3),
                    indicatorStyle: IndicatorStyle(
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(5),
                    ),
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
      )),
    );
  }

  _getOrderInfo() async {
    await FirebaseDatabase.instance
        .ref('sellers/$uid/orders/${widget.orderId}')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          orderInfo = value.value as Map;
          date = DateTime.fromMillisecondsSinceEpoch(
              int.parse(orderInfo['order_date'].toString()));
          orderStatus = orderInfo['order_status'] != null
              ? orderInfo['order_status']
              : 'unknown';
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

  _updateOrderStatus(String status) async {
    await FirebaseDatabase.instance
        .ref('sellers/${uid}/orders/${widget.orderId}')
        .update({'order_status': status});

    await FirebaseDatabase.instance
        .ref('users/${orderInfo['customer_id']}/order/${widget.orderId}')
        .update({'order_status': status}).then((value) {
      setState(() {
        orderStatus = status;
      });
    });
  }
}
