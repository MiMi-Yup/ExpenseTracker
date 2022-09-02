import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/asset/bank.dart';
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/currency_types.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetDefault extends StatefulWidget {
  const SetDefault({Key? key}) : super(key: key);

  @override
  State<SetDefault> createState() => _SetDefaultState();
}

class _SetDefaultState extends State<SetDefault> {
  bool setWallet = false;
  ModalAccountType? choseAccountType;
  int? _value;
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
  ModalCurrencyType? choseCurrency;
  late TextEditingController controller;
  String? errorText;

  UserFirestore userFirestore = UserFirestore();
  CurrencyTypesFirestore currencyTypesFirestore = CurrencyTypesFirestore();
  AccountTypeFirestore accountTypeFirestore = AccountTypeFirestore();

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
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 40.0),
              decoration: InputDecoration(
                  prefixText: '${choseCurrency?.currencyCode} ',
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
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            child: FutureBuilder<List<ModalAccountType>>(
                              initialData: [],
                              future: accountTypeFirestore.read(),
                              builder: (context, snapshot) =>
                                  DropDown<ModalAccountType>(
                                hint: "Choose account type",
                                items: snapshot.data!,
                                chosenValue: choseAccountType,
                                onChanged: (itemSelected) {
                                  setState(() {
                                    choseAccountType = itemSelected;
                                  });
                                },
                              ),
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
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      child: FutureBuilder<List<ModalCurrencyType>>(
                        initialData: [],
                        future: currencyTypesFirestore.read(),
                        builder: (context, snapshot) =>
                            DropDown<ModalCurrencyType>(
                          hint: "Choose currency type",
                          items: snapshot.data!,
                          chosenValue: choseCurrency,
                          onChanged: (itemSelected) {
                            setState(() {
                              choseCurrency = itemSelected;
                            });
                          },
                        ),
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
                                userFirestore.read().then((value) {
                                  if (value.isNotEmpty) {
                                    ModalUser fieldUser = value.first;
                                    fieldUser.wasSetup = true;
                                    userFirestore.update(null, fieldUser);
                                  } else {
                                    userFirestore.insert(ModalUser(
                                        id: null,
                                        email: null,
                                        password: null,
                                        wasSetup: true));
                                  }
                                });

                                DocumentReference accountTypeRef =
                                    accountTypeFirestore
                                        .getRef(choseAccountType!);
                                AccountFirestore().insert(ModalAccount(
                                    id: choseAccountType!.id,
                                    accountTypeRef: accountTypeRef,
                                    money: double.tryParse(controller.text)));
                                userFirestore.read().then((value) {
                                  if (value.isNotEmpty) {
                                    ModalUser modal = value.first;
                                    modal.currencyTypeRef =
                                        currencyTypesFirestore
                                            .getRef(choseCurrency!);
                                    modal.wasSetup = true;
                                    userFirestore.insert(modal);
                                  }
                                });

                                RouteApplication.navigatorKey.currentState
                                    ?.popUntil((route) => false);
                                RouteApplication.navigatorKey.currentState
                                    ?.pushNamed(
                                        RouteApplication.getRoute(ERoute.main));
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
