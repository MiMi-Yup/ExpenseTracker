import 'package:expense_tracker/page/introduction.dart';
import 'package:expense_tracker/page/signup/signup.dart';
import 'package:expense_tracker/page/signup/verify.dart';
import 'package:expense_tracker/page/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: OTPVerify(),
    );
  }
}
