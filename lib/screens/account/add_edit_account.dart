import 'dart:async';

import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/currency_type_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
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
  TextEditingController? controller;
  String? errorText;

  UserFirestore userFirestore = UserFirestore();
  CurrencyTypesFirestore currencyTypesFirestore = CurrencyTypesFirestore();
  AccountTypeFirestore accountTypeFirestore = AccountTypeFirestore();

  late Object? arguments = ModalRoute.of(context)?.settings.arguments;
  late Future<void> Function(
      ModalAccountType? accountType,
      ModalCurrencyType? currencyType,
      double? balance)? callWhenFinish = arguments != null &&
          arguments is List &&
          (arguments as List)[0] is Future<void> Function(
              ModalAccountType?, ModalCurrencyType?, double?)
      ? (arguments as List)[0] as Future<void> Function(
          ModalAccountType?, ModalCurrencyType?, double?)
      : throw ArgumentError("Required action when complete");
  late ModalAccount? accountEditModal =
      arguments != null && arguments is List && (arguments as List).length == 2
          ? (arguments as List)[1] as ModalAccount
          : null;

  ///arguments has 2 elements
  ///[0] is Future<void> Function(ModalAccountType?, ModalCurrencyType?, double?) which action when complete
  ///[1] is ModalAccount which edit account

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      controller =
          TextEditingController(text: accountEditModal?.money.toString());
      controller?.addListener(() {
        setState(() {
          errorText = controller!.text.isEmpty ? null : 'Not empty';
        });
      });

      if (accountEditModal != null) {
        choseAccountType = AccountTypeInstance.instance()
            .getModal(accountEditModal!.accountTypeRef!.id);
        controller?.text = accountEditModal!.money.toString();
        choseCurrency = CurrencyTypeInstance.instance()
            .getModal(accountEditModal!.currencyTypeRef!.id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: MyColor.mainBackgroundColor,
        title:
            Text(accountEditModal == null ? "Add new account" : "Edit account"),
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
                                controller!.text.isNotEmpty) {
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
                                    double.tryParse(controller!.text));
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
