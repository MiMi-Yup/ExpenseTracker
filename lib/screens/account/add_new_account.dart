import 'dart:async';

import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:expense_tracker/services/firebase/firestore/currency_types.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class AddNewAccount extends StatefulWidget {
  const AddNewAccount({Key? key}) : super(key: key);

  @override
  State<AddNewAccount> createState() => _AddNewAccountState();
}

class _AddNewAccountState extends State<AddNewAccount> {
  ModalAccountType? choseAccountType;
  ModalCurrencyType? choseCurrency;
  late TextEditingController controller;
  String? errorText;

  UserFirestore userFirestore = UserFirestore();
  CurrencyTypesFirestore currencyTypesFirestore = CurrencyTypesFirestore();
  AccountTypeFirestore accountTypeFirestore = AccountTypeFirestore();

  late Object? arguments = ModalRoute.of(context)?.settings.arguments;
  late Future<void> Function(ModalAccountType? accountType,
          ModalCurrencyType? currencyType, double? balance)? callWhenFinish =
      arguments == null
          ? null
          : arguments as Future<void> Function(
              ModalAccountType?, ModalCurrencyType?, double?);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {
      setState(() {
        errorText = controller.text.isEmpty ? null : 'Not empty';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: MyColor.mainBackgroundColor,
        title: Text("Add new account"),
        leading: IconButton(
            onPressed: () => RouteApplication.navigatorKey.currentState?.pop(),
            icon: Icon(Icons.arrow_back_ios)),
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
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 40.0),
              decoration: InputDecoration(
                  prefixText: '${choseCurrency?.currencyCode ?? "Currency"} ',
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
                  Row(
                    children: [
                      Text("Account types"),
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 10.0),
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            child: FutureBuilder<List<ModalAccountType>?>(
                              initialData: [],
                              future: accountTypeFirestore.read(),
                              builder: (context, snapshot) =>
                                  DropDown<ModalAccountType>(
                                hint: "Choose account type",
                                items: snapshot.data!,
                                choseValue: choseAccountType,
                                onChanged: (itemSelected) =>
                                    choseAccountType = itemSelected,
                              ).builder(),
                            )),
                      ),
                      TextButton(
                          onPressed: () => RouteApplication
                              .navigatorKey.currentState
                              ?.pushNamed(RouteApplication.getRoute(
                                  ERoute.addEditAccountType)),
                          child: Text("New"))
                    ],
                  ),
                  Row(
                    children: [
                      Text("Currency account"),
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 10.0),
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            child: FutureBuilder<List<ModalCurrencyType>?>(
                              initialData: [],
                              future: currencyTypesFirestore.read(),
                              builder: (context, snapshot) =>
                                  DropDown<ModalCurrencyType>(
                                hint: "Choose currency type",
                                items: snapshot.data!,
                                choseValue: choseCurrency,
                                onChanged: (itemSelected) => setState(
                                    () => choseCurrency = itemSelected),
                              ).builder(),
                            )),
                      )
                    ],
                  ),
                  Container(
                      width: double.maxFinite,
                      child: largestButton(
                          text: "Continue",
                          onPressed: () {
                            if (choseAccountType != null &&
                                choseCurrency != null &&
                                controller.text.isNotEmpty) {
                              showDialog(
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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

                              Future.delayed(const Duration(seconds: 1),
                                  () async {
                                await callWhenFinish?.call(
                                    choseAccountType,
                                    choseCurrency,
                                    double.tryParse(controller.text));
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please fill all fields")));
                            }
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
