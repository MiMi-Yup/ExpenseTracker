import 'package:flutter/material.dart';

Widget overviewTransaction() {
  return Container(
      padding: EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("asset/image/income.png"),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Income"),
              Text(
                "\$5000",
                style: TextStyle(fontSize: 20.0),
              )
            ],
          )
        ],
      ));
}
