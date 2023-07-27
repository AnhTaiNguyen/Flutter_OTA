import 'package:OTA/screens/home_screen.dart';
import 'package:OTA/screens/signup_screen.dart';
import 'package:OTA/screens/update_screen.dart';
import 'package:OTA/screens/vehicel_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:OTA/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}
