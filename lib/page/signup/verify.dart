import 'dart:developer';

import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/countdown.dart';
import 'package:expense_tracker/widget/input_otp.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({Key? key}) : super(key: key);

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  String email = "dsfsd@gmail.com";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
        leading: IconButton(
            onPressed: () => null, icon: Icon(Icons.arrow_back_ios_new)),
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enter your Code",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          countdown(
              time: Duration(minutes: 0, seconds: 5),
              finished: () => log("finished")),
          CodeInput(
              length: 5,
              builder: CodeInputBuilders.lightCircle(),
              keyboardType: TextInputType.number,
              onChanged: (value) => null),
          Padding(
            padding: const EdgeInsets.only(
                top: 25.0, left: 8.0, right: 8.0, bottom: 25.0),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(text: "We send verification code to your email "),
              TextSpan(
                  text: email,
                  style: TextStyle(color: MyColor.purple(alpha: 255))),
              TextSpan(text: " You can check your inbox.")
            ])),
          ),
          GestureDetector(
            onTap: () => null,
            child: Text(
              "I didn’t received the code? Send again",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: MyColor.purple(alpha: 255)),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(20.0),
            child: largestButton(
                text: "Verify",
                onPressed: () => null,
                background: MyColor.purple(alpha: 255)),
          )
        ],
      ),
    );
  }
}
