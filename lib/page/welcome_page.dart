import 'package:expense_tracker/constant/color.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
              decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
            ),
          ),
          Container(
        decoration: BoxDecoration(color: MyColor.purple(alpha: 200)),
        child: Center(
          child: Text(
            "montra",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
          ),
        ),
      )
        ],
      ),
    );
  }
}
