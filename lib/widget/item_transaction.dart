import 'package:flutter/material.dart';

GestureDetector itemTransaction({void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.blueAccent),
      width: double.maxFinite,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: Image.asset("asset/image/mandiri_bank.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [Text("data"), Text("data")],
              ),
            ),
          ],
        ),
        Column(
          children: [Text("data"), Text("data")],
        ),
      ]),
    ),
  );
}
