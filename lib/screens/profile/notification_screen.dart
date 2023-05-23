import 'dart:async';
import 'dart:ffi';

import 'package:Kirana/constants/ConstantValue.dart';
import 'package:Kirana/tools/custom_toast.dart';
import "package:flutter/material.dart";
import 'package:Kirana/constants/SystemColors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // bool _isVisible = true;
  // double _transform = 80;
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: mainColor,
  //       automaticallyImplyLeading: false,
  //       leading: IconButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           icon: const Icon(
  //             Icons.arrow_back_ios_new_rounded,
  //             color: Colors.white,
  //           )),
  //       title: Text(
  //         "Notifications",
  //         style: TextStyle(color: textColor),
  //       ),
  //       centerTitle: true,
  //     ),
  //     body: Container(
  //       height: getScreenSize(context).height,
  //       width: getScreenSize(context).width,
  //       child: Stack(children: [
  //         // Center(
  //         //     child: ElevatedButton(
  //         //         onPressed: () {
  //         //           setState(() {
  //         //             _isVisible = !_isVisible;
  //         //           });
  //         //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         //             content: CustomToast(),
  //         //             behavior: SnackBarBehavior.floating,
  //         //           ));
  //         //         },
  //         //         child: Text('click'))),
  //       ]),
  //     ),
  //   );
  // }

  String currentStatus = 'Delivered';
  List<String> statusList = [
    'Preparing',
    'Packed',
    'Out for Delivery',
    'Delivered'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Current Status:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            currentStatus,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Text(
            'Status History:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: statusList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        (index <= statusList.indexOf(currentStatus))
                            ? Colors.green
                            : Colors.grey,
                    child: Icon(
                      (index <= statusList.indexOf(currentStatus))
                          ? Icons.check
                          : Icons.radio_button_unchecked,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    statusList[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (index <= statusList.indexOf(currentStatus))
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  subtitle: Text(
                    (index < statusList.indexOf(currentStatus))
                        ? 'Delivered on ${DateTime.now().toString()}'
                        : '',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
