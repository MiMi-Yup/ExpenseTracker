import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/editText.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddNewAccount extends StatelessWidget {
  const AddNewAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new account"),
        leading:
            IconButton(onPressed: () => null, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Balance",
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
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  editText(
                      onChanged: (value) => null,
                      hintText: "Name",
                      labelText: "Name"),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      child: dropDown(
                        items: <String>[
                          'Android',
                          'IOS',
                          'Flutter',
                          'Node',
                          'Java',
                          'Python',
                          'PHP',
                        ],
                        onChanged: (p0) => null,
                      )),
                      
                  Container(
                      width: double.maxFinite,
                      child: largestButton(
                          text: "Continue",
                          onPressed: () => null,
                          background: MyColor.purple()))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
