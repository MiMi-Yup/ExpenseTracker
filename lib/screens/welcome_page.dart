import 'dart:async';

import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double opacityLevel = 0.0;
  Timer? _timer;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  Future<void> initApplication() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        RouteApplication.navigatorKey.currentState?.pushReplacementNamed(
            RouteApplication.getRoute(ERoute.introduction));
      } else {
        RouteApplication.navigatorKey.currentState
            ?.popUntil((route) => route.isFirst);
        RouteApplication.navigatorKey.currentState?.pushReplacementNamed(
            RouteApplication.getRoute(ERoute.pin), arguments: false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(seconds: 2), (timer) => _changeOpacity());
    initApplication();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.redAccent, shape: BoxShape.circle),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: MyColor.purple(alpha: 200)),
            child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: opacityLevel,
                child: Center(
                  child: Text(
                    "montra",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
