import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => RouteApplication.navigatorKey.currentState?.pop(),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text("Export"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What data do you want to export?"),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white70,
                  ),
                  borderRadius: BorderRadius.circular(10.0)),
              child: DropDown<String>(
                  hint: "Type transaction export",
                  items: ["All", "Income", "Expense"],
                  choseValue: "All",
                  onChanged: (value) => null).builder(),
            ),
            Text("When date range?"),
            Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white70,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: DropDown<String>(
                    hint: "During time export",
                    items: [
                      "Last 30 days",
                      "Last 3 months",
                      "Last nearly year"
                    ],
                    choseValue: "Last 30 days",
                    onChanged: (value) => null).builder()),
            Text("What format do you want to export?"),
            Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white70,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: DropDown<String>(
                    hint: "Extension files export",
                    items: ["CSV", "Excel", "SpreadSheet"],
                    choseValue: "CSV",
                    onChanged: (value) => null).builder()),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.maxFinite,
                child: largestButton(text: "Export", onPressed: () => null),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
