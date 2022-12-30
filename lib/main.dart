import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/splash/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          primaryColor: Colors.green),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
