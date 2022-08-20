import 'package:expense_tracker/constant/enum/enum_route.dart';
import 'package:expense_tracker/route.dart';
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
      routes: RouteApplication.routes,
      initialRoute: RouteApplication.getRoute(ERoute.welcome),
    );
  }
}
