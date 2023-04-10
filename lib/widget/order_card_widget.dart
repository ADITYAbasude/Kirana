import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCardWidget extends StatefulWidget {
  final orderData;
  OrderCardWidget(this.orderData);

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  var productInfo;
  @override
  void initState() {
    _getProductInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.orderData['order_date'].toString()));
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green.shade100),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        productInfo != null
                            ? 'Order #' + widget.orderData['order_id']
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
                                  ? 'Quantity ${widget.orderData['product_quantity']}'
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              productInfo != null
                                  ? 'Price ₹${widget.orderData['product_price']}'
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
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
    );
  }

  void _getProductInfo() async {
    await FirebaseDatabase.instance
        .ref(
            'sellers/${widget.orderData['seller_id']}/products/${widget.orderData['product_id']}/info')
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
