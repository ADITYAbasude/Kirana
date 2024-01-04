import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/SystemColors.dart';
import '../../utils/get_info.dart';

class StoreAnalytics extends StatefulWidget {
  const StoreAnalytics({Key? key}) : super(key: key);

  @override
  _StoreAnalyticsState createState() => _StoreAnalyticsState();
}

class _StoreAnalyticsState extends State<StoreAnalytics> {
  // it store the all orders details of the seller
  List orders = [];

  // it store the orders date and number of orders
  List<ordersInfoObject> ordersInfo = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getAllOrders();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      _getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Analytics",
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: ListView(children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '1.5k',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text('Impression', style: TextStyle(fontSize: 16))
                    ],
                  ),
                  const SizedBox(height: 50, child: VerticalDivider()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        orders.length.toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                      Text('Orders', style: TextStyle(fontSize: 16))
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SfCartesianChart(
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Number of orders'),
                  edgeLabelPlacement: EdgeLabelPlacement.none,
                  majorGridLines: MajorGridLines(color: Colors.transparent),
                ),
                primaryXAxis: DateTimeAxis(
                  title: AxisTitle(text: 'Date'),
                  edgeLabelPlacement: EdgeLabelPlacement.none,
                  majorGridLines: MajorGridLines(color: Colors.transparent),
                  dateFormat: DateFormat.MMMd(),
                  minimum: ordersInfo.isNotEmpty
                      ? ordersInfo[0].date
                      : DateTime.now(),
                  maximum: DateTime.now(),
                  // interval: 2,
                ),
                annotations: [
                  CartesianChartAnnotation(
                    widget: Center(child: Text('Hello')),
                  )
                ],
                title: ChartTitle(text: 'Orders per day'),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<ordersInfoObject, DateTime>>[
                  FastLineSeries<ordersInfoObject, DateTime>(
                    enableTooltip: true,
                    color: mainColor,
                    dataSource: ordersInfo,
                    markerSettings: MarkerSettings(isVisible: true),
                    xAxisName: 'numbers of orders',
                    xValueMapper: (ordersInfoObject sales, _) => sales.date,
                    yValueMapper: (ordersInfoObject sales, _) =>
                        sales.numberOfOrders,
                  )
                ],
              ),
            ),
          ])),
    );
  }

  _getAllOrders() async {
    orders.clear();
    // first, collect all orders of the seller
    await FirebaseDatabase.instance
        .ref('sellers/$uid/orders')
        .get()
        .then((value) {
      for (var order in value.children) {
        var orderData = order.value as Map;
        setState(() {
          orders.add(order.value);
        });
      }
      orders.sort((a, b) => a['order_date'].compareTo(b['order_date']));
    });

    //algorithm to find the number of orders per day
    ordersInfo.clear();
    if (orders.isNotEmpty) {
      var date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(orders[0]['order_date'].toString()));
      var numberOfOrders = 0;
      for (var order in orders) {
        var orderDate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(order['order_date'].toString()));
        if (orderDate.day == date.day) {
          numberOfOrders++;
        } else {
          ordersInfo.add(ordersInfoObject(date, numberOfOrders));
          date = orderDate;
          numberOfOrders = 1;
        }
      }
      ordersInfo.add(ordersInfoObject(date, numberOfOrders));
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}

class ordersInfoObject {
  ordersInfoObject(this.date, this.numberOfOrders);

  final DateTime date;
  final int numberOfOrders;
}
