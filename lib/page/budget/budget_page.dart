import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/item_budget.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  bool hasData = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: MyColor.mainBackgroundColor,
          leading:
              IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(onPressed: null, icon: Icon(Icons.arrow_forward_ios))
          ],
          title: Text("Month"),
          centerTitle: true,
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(16.0),
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0))),
          child: Column(
            children: [
              Expanded(
                  child: hasData
                      ? MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView(
                            children: List.generate(
                                20,
                                (index) => itemBudget(
                                    width: MediaQuery.of(context).size.width,
                                    percent: 0.45)),
                          ))
                      : Center(
                          child: Text(
                          "You don't have a budget",
                          style: TextStyle(color: Colors.black),
                        ))),
              SizedBox(
                  width: double.maxFinite,
                  child: largestButton(
                      text: "Create a budget", onPressed: () => null))
            ],
          ),
        ))
      ],
    );
  }
}
