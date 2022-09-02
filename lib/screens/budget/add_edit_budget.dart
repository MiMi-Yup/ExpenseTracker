import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddEditBudget extends StatefulWidget {
  const AddEditBudget({Key? key}) : super(key: key);

  @override
  State<AddEditBudget> createState() => _AddEditBudgetState();
}

class _AddEditBudgetState extends State<AddEditBudget> {
  bool _isAlert = false;
  double _percentAlert = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:
              IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
          elevation: 0,
          backgroundColor: MyColor.mainBackgroundColor,
          title: Text("Budget"),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "How much do you want to spend?",
                  style: TextStyle(fontSize: 25.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 40.0),
                  decoration: InputDecoration(
                      prefixText: "\$",
                      isCollapsed: true,
                      hintText: "\0.00",
                      border: InputBorder.none),
                ),
              ),
            ]),
        bottomSheet: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "How much do you want to spend?",
                  style: TextStyle(fontSize: 25.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 40.0),
                  decoration: InputDecoration(
                      prefixText: "\$",
                      isCollapsed: true,
                      hintText: "\0.00",
                      border: InputBorder.none),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropDown<String>(
                        isExpanded: true,
                        hint: "Category",
                        items: ["Shopping", "Eat"],
                        choseValue: null,
                        onChanged: (value) => null),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Receive Alert",
                                style: TextStyle(color: Colors.black)),
                            Text(
                              "Receive alert when it reaches",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ],
                        ),
                        Switch(
                            value: _isAlert,
                            onChanged: (value) =>
                                setState(() => _isAlert = value))
                      ],
                    ),
                    Visibility(
                        visible: _isAlert,
                        child: Row(
                          children: [
                            Expanded(
                                child: Slider(
                                    value: _percentAlert,
                                    onChanged: (value) =>
                                        setState(() => _percentAlert = value))),
                            Text(
                              "${(_percentAlert * 100.0).round()}%",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )),
                    SizedBox(
                      width: double.maxFinite,
                      child: largestButton(
                          text: "Continue", onPressed: () => null),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
