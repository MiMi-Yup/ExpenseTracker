import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.currentUser?.reload();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RouteApplication.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      routes: RouteApplication.routes,
      initialRoute: RouteApplication.getRoute(ERoute.welcome),
    );
  }
}
