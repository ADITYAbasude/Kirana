// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants/SystemColors.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: 'lib/.env');
  Stripe.publishableKey = dotenv.get("stripe_pay_publishable_key");
  Stripe.stripeAccountId = 'acct_1N01KGSGkthyrkck';
  Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kirana',
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
            primary: mainColor,
            secondary: mainColor,
            onPrimary: mainColor,
            onSecondary: mainColor),
        primarySwatch: mainColor,
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            modalBackgroundColor: Colors.transparent,
            modalBarrierColor: Colors.transparent,
            surfaceTintColor: Colors.transparent),
        dialogTheme: const DialogTheme(surfaceTintColor: Colors.transparent),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: mainColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                surfaceTintColor:
                    MaterialStateColor.resolveWith((states) => mainColor))),
        dividerColor: Colors.black.withOpacity(0),
        appBarTheme: AppBarTheme(backgroundColor: mainColor),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(indicatorColor: mainColor),
        fontFamily: 'OpenSens',
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
