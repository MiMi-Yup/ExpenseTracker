import 'package:expense_tracker/constants/color.dart';
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
            onPressed: () => Navigator.pop<void>(context),
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
              child: dropDown(
                  hintText: "Type transaction export",
                  items: ["All", "Income", "Expense"],
                  chosenValue: "All",
                  onChanged: (value) => null),
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
                child: dropDown(
                    hintText: "During time export",
                    items: [
                      "Last 30 days",
                      "Last 3 months",
                      "Last nearly year"
                    ],
                    chosenValue: "Last 30 days",
                    onChanged: (value) => null)),
            Text("What format do you want to export?"),
            Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white70,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: dropDown(
                    hintText: "Extension files export",
                    items: ["CSV", "Excel", "SpreadSheet"],
                    chosenValue: "CSV",
                    onChanged: (value) => null)),
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
