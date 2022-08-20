import 'dart:async';

import 'package:expense_tracker/constant/asset/bank.dart';
import 'package:expense_tracker/constant/asset/icon.dart';
import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/constant/enum/enum_route.dart';
import 'package:expense_tracker/route.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/editText.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';

class AddNewAccount extends StatefulWidget {
  const AddNewAccount({Key? key}) : super(key: key);

  @override
  State<AddNewAccount> createState() => _AddNewAccountState();
}

class _AddNewAccountState extends State<AddNewAccount> {
  bool setWallet = false;
  String? _chosenValue;
  int? _value;
  final String _addWallet = "Wallet";
  final List<String> _listBank = [
    BankAsset.bankOfAmerica,
    BankAsset.bcaBank,
    BankAsset.chaseBank,
    BankAsset.cityBank,
    BankAsset.jagoBank,
    BankAsset.mandiriBank,
    BankAsset.paypalBank
  ];
  final List<String> _listDropDown = [
    'Android',
    'IOS',
    'Flutter',
    'Node',
    'Java',
    'Python',
    'PHP',
    "Wallet"
  ];

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: MyColor.mainBackgroundColor,
        title: Text(setWallet ? "Add new wallet" : "Add new account"),
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
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      child: dropDown(
                        hintText: "Choose account type",
                        items: _listDropDown,
                        chosenValue: _chosenValue,
                        onChanged: (itemSelected) {
                          _chosenValue = itemSelected;
                          setState(() => itemSelected == _addWallet
                              ? setWallet = true
                              : setWallet = false);
                        },
                      )),
                  Visibility(
                    visible: setWallet,
                    child: Wrap(
                      spacing: 8.0,
                      children: List<Widget>.generate(
                        _listBank.length,
                        (int index) {
                          return ChoiceChip(
                            label: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(_listBank[index]),
                            ),
                            selected: _value == index,
                            onSelected: (selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                            selectedColor: Colors.white70,
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Container(
                      width: double.maxFinite,
                      child: largestButton(
                          text: "Continue",
                          onPressed: () {
                            showDialog(
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        IconAsset.success,
                                        scale: 2,
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                          "Transaction has been successfully added")
                                    ],
                                  ),
                                ),
                              ),
                              context: context,
                            );

                            _timer = Timer(const Duration(seconds: 1), () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushNamed(context,
                                  RouteApplication.getRoute(ERoute.main));
                            });
                          },
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
