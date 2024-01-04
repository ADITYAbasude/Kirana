import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants/SystemColors.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
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
        primarySwatch: MaterialColor(mainColor.value, {
          50: mainColor,
          100: mainColor,
          200: mainColor,
          300: mainColor,
          400: mainColor,
          500: mainColor,
          600: mainColor,
          700: mainColor,
          800: mainColor,
          900: mainColor,
        }),
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
