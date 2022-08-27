import 'dart:async';
import 'dart:developer';

import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/widgets/input_otp.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({Key? key}) : super(key: key);

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  String email = "dsfsd@gmail.com";
  Duration _timeCountDown = Duration(seconds: 5);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() =>
          _timeCountDown = Duration(seconds: _timeCountDown.inSeconds - 1));
      if (_timeCountDown.inSeconds == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
        leading: IconButton(
            onPressed: () => null, icon: Icon(Icons.arrow_back_ios_new)),
        elevation: 0.0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enter your Code",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text(
            "${_timeCountDown.inMinutes}:${_timeCountDown.inSeconds - _timeCountDown.inMinutes * 60}",
            style: TextStyle(fontSize: 20, color: Colors.amber),
          ),
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
