import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/overview_transaction.dart';
import 'package:flutter/material.dart';

Widget homePage() {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
          gradient: LinearGradient(
              colors: [
                const Color(0xFF3366FF),
                const Color(0xFF00CCFF),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: GestureDetector(
                onTap: null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: MyColor.purple(),
                      foregroundImage:
                          AssetImage("asset/image/paypal_bank.png")),
                ),
              ),
              title: dropDown(
                  items: ["1", "2", "3"],
                  chosenValue: null,
                  onChanged: (p0) => null),
              actions: [
                IconButton(onPressed: null, icon: Icon(Icons.notifications))
              ],
            ),
            Text("Account balance"),
            Text("\$9400", style: TextStyle(fontSize: 30.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                overviewTransaction(),
                overviewTransaction()
              ],
            )
          ],
        ),
      )
    ],
  );
}
