// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/splash/splash_screen.dart';

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
          primarySwatch: Colors.green,
          useMaterial3: true,
          fontFamily: 'OpenSens',
          primaryColor: Colors.green),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
