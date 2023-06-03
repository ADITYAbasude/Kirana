import 'package:Kirana/tools/SnackBar.dart';
import 'package:Kirana/utils/get_info.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/utils/screen_size.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class BuyProductWidget extends StatefulWidget {
  final controller;
  final productData;
  Function updateProductStockCallback;
  BuyProductWidget(
      this.controller, this.productData, this.updateProductStockCallback);

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

  late int _totalOrdersOfProduct;

  BillingDetails? _billingDetails;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    _time = Time(hour: _currentTime.hour, minute: _currentTime.minute);
    getAddress();
    _scheduleTime = "${_time.hour.toString()}:${_time.minute.toString()}";
    _totalOrdersOfProduct = widget.productData['total_orders'] ?? 0;
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
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
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
                child: Text(
              'You have to pay : ₹${widget.productData['product_price']}',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            )),
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
                  onPressed: () async {
                    var paymentIntent = await createPaymentIntent(34, 'INR');
                    var paymentSheet = await Stripe.instance.initPaymentSheet(
                        paymentSheetParameters: SetupPaymentSheetParameters(
                      // Main params
                      paymentIntentClientSecret: paymentIntent['client_secret'],
                      merchantDisplayName: 'Kirana',
                      // Customer params
                      customerId: uid,
                      googlePay: PaymentSheetGooglePay(
                        merchantCountryCode: 'DE',
                        testEnv: true,
                      ),
                      style: ThemeMode.light,
                      billingDetails: _billingDetails,
                    ));

                    await Stripe.instance.presentPaymentSheet().then((value) {
                      _orderProduct();
                    }).onError((error, stackTrace) {});
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
    _addressController.text = SplashScreen.address;
  }

  _orderProduct() async {
    if (_addressController.text.isNotEmpty) {
      _totalOrdersOfProduct++;

      //* update the product stock after the user purchase the product
      int productStockUpdate = widget.productData['product_unit'] == '/ 500 g'
          ? widget.productData['product_stock'] - 500
          : widget.productData['product_stock'] - 1;

      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('users/$uid/order').push();

      String pushKey = dbRef.key.toString();

      Map<String, dynamic> orderObject = {
        'product_id': widget.productData['product_id'],
        'seller_id': widget.productData['seller_id'],
        'order_date': _currentTime.millisecondsSinceEpoch.toString(),
        'schedule_time': _scheduleAnswer == timeScheduleAnswer.no
            ? DateTime.now().millisecondsSinceEpoch.toString()
            : _scheduleAnswer,
        'order_id': pushKey,
        'payment_method': _paymentType.substring(15).toString(),
        'product_quantity': 1,
        'product_price': widget.productData['product_price'],
        'customer_id': uid,
        'customer_address': _addressController.text,
      };

      await FirebaseDatabase.instance
          .ref('sellers/${widget.productData['seller_id']}/orders/$pushKey')
          .set(orderObject)
          .whenComplete(() async {
        await dbRef.set(orderObject).then((value) async {
          await FirebaseDatabase.instance
              .ref(
                  'sellers/${widget.productData['seller_id']}/products/${widget.productData['product_id']}/info')
              .update({
            'total_orders': _totalOrdersOfProduct,
            'product_stock': productStockUpdate
          }).whenComplete(() {});
          // Scaffold
          showSnackBar(context, 'Order placed successfully');
        });
      });
    } else {
      showSnackBar(context, 'Fill your address field');
    }
  }

  dynamic createPaymentIntent(int amount, String currency) async {
    final dio = Dio();
    try {
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          options: Options(headers: {
            'Authorization':
                'Bearer sk_test_51N01KGSGkthyrkckIaXtj0BAOFMQe1mdfW7jYqGNbYNKcSEM87EofN4uM1MYgcNU7gzS4BCN8SuSQx4gBDfrMVMI00nCBT7bRM',
            'Content-Type': 'application/x-www-form-urlencoded',
          }),
          queryParameters: {'amount': 1000, 'currency': currency});
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
