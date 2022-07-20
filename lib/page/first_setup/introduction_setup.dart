import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class IntroductionSetup extends StatelessWidget {
  const IntroductionSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 125.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let’s setup your account!",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Account can be your bank, credit card or your wallet.",
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.all(25.0),
            child: largestButton(text: "Let’s go", onPressed: () => null),
          )
        ],
      ),
    );
  }
}
