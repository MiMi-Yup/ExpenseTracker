import 'dart:async';

import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/constant/route.dart';
import 'package:expense_tracker/route.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double opacityLevel = 0.0;
  late Timer _timer;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  Future<void> initApplication() async {
    Timer(
        const Duration(seconds: 5),
        () => Navigator.popAndPushNamed(
            context, RouteApplication.getRoute(ERoute.introduction)));
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
    _timer.cancel();
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
