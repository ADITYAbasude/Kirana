// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';

import 'constants/SystemColors.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: mainColor,
        ),
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
