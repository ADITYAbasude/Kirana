import 'package:Kirana/tools/SnackBar.dart';
import 'package:Kirana/utils/get_info.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/constants/ConstantValue.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';

class BuyProductWidget extends StatefulWidget {
  final controller;
  final productData;
  BuyProductWidget(this.controller, this.productData);

  @override
  State<BuyProductWidget> createState() => _BuyProductWidgetState();
}

enum timeScheduleAnswer { yes, no }

enum PaymentMethods { Online, Cash }

class _BuyProductWidgetState extends State<BuyProductWidget> {
  final _currentTime = DateTime.now();
  late Time _time;
  final _addressController = TextEditingController();
  late String _scheduleTime;
  timeScheduleAnswer? _scheduleAnswer = timeScheduleAnswer.no;
  PaymentMethods? _paymentMethods = PaymentMethods.Online;
  String _paymentType = PaymentMethods.Online.toString();
  @override
  void initState() {
    _time = Time(hour: _currentTime.hour, minute: _currentTime.minute);
    getAddress();
    _scheduleTime = "${_time.hour.toString()}:${_time.minute.toString()}";
    super.initState();
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
      _scheduleTime = "${_time.hour.toString()}:${_time.minute.toString()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: getScreenSize(context).width,
        height: getScreenSize(context).height,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: ListView(
          controller: widget.controller,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 10, top: 15),
                child: const Text(
                  "Your delivery address",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )),
            Container(
                margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
                child: TextField(
                  controller: _addressController,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 2,
                  minLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(left: 10, top: 20),
                child: const Text('Do you want to schedule a delivery time?',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<timeScheduleAnswer>(
                      title: const Text('Yes'),
                      value: timeScheduleAnswer.yes,
                      groupValue: _scheduleAnswer,
                      onChanged: (timeScheduleAnswer? value) {
                        setState(() {
                          // Update map value on tap
                          _scheduleAnswer = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<timeScheduleAnswer>(
                      title: const Text('No'),
                      value: timeScheduleAnswer.no,
                      groupValue: _scheduleAnswer,
                      onChanged: (timeScheduleAnswer? value) {
                        setState(() {
                          _scheduleAnswer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _scheduleAnswer == timeScheduleAnswer.no ? false : true,
              child: AnimatedContainer(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
                  duration: const Duration(seconds: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        showPicker(
                            context: context,
                            value: _time,
                            onChange: onTimeChanged,
                            is24HrFormat: true),
                      );
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: const Border(
                            top: BorderSide(color: Colors.green, width: 2),
                            left: BorderSide(color: Colors.green, width: 2),
                            right: BorderSide(color: Colors.green, width: 2),
                            bottom: BorderSide(color: Colors.green, width: 2)),
                      ),
                      child: Text(
                        _scheduleTime,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  )),
            ),
            Container(
                margin: const EdgeInsets.only(left: 10, top: 20),
                child: const Text('Select your payment method',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<PaymentMethods>(
                      title: const Text('Online'),
                      value: PaymentMethods.Online,
                      groupValue: _paymentMethods,
                      onChanged: (PaymentMethods? value) {
                        setState(() {
                          // Update map value on tap
                          _paymentType = value.toString();
                          _paymentMethods = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<PaymentMethods>(
                      title: const Text('Cash'),
                      value: PaymentMethods.Cash,
                      groupValue: _paymentMethods,
                      onChanged: (PaymentMethods? value) {
                        setState(() {
                          _paymentType = value.toString();
                          _paymentMethods = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              height: 45,
              child: ElevatedButton.icon(
                  icon: Icon(
                    _paymentMethods == PaymentMethods.Online
                        ? Icons.payment_rounded
                        : Icons.shopping_bag_outlined,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _orderProduct();
                  },
                  label: Text(
                    _paymentMethods == PaymentMethods.Online ? "Pay" : 'Order',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 80,
        height: 5,
        decoration: BoxDecoration(
            color: const Color.fromARGB(123, 255, 255, 255),
            borderRadius: BorderRadius.circular(20)),
        transform: Matrix4.translationValues(0.0, -15, 0.0),
        child: const SizedBox(
          width: 80,
          height: 5,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }

  getAddress() async {
    _addressController.text = await SplashScreen.address;
  }

  _orderProduct() async {
    if (_addressController.text.isNotEmpty) {
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('users/$uid/order').push();

      String pushKey = dbRef.key.toString();

      Map<String, dynamic> orderObject = {
        'product_id': widget.productData['product_id'],
        'seller_id': widget.productData['seller_id'],
        'order_date': _currentTime.millisecondsSinceEpoch.toString(),
        'schedule_time': _scheduleTime,
        'order_id': pushKey,
        'payment_method': _paymentType,
      };

      dbRef.set(orderObject).then((value) {
        showSnackBar(context, 'Order placed successfully');
      });
    } else {
      showSnackBar(context, "Fill your address field");
    }
  }
}
