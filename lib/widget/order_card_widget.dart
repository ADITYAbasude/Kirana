import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                child: Image.network(
                  productInfo['product_image'] ?? '',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
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
      print(value.value);
      if (value.exists) {
        setState(() {
          productInfo = value.value as Map;
        });
      }
    });
  }
}
