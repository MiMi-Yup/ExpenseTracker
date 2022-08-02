import 'package:flutter/material.dart';

Widget itemTransaction() {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), color: Colors.blueAccent),
    width: double.maxFinite,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(
        children: [
          Image.asset("asset/image/mandiri_bank.png"),
          Column(
            children: [Text("data"), Text("data")],
          ),
        ],
      ),
      Column(
        children: [Text("data"), Text("data")],
      ),
    ]),
  );
}
