import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/currency_type_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/currency_types.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class IntroductionSetup extends StatelessWidget {
  IntroductionSetup({Key? key}) : super(key: key);

  UserFirestore userFirestore = UserFirestore();
  CurrencyTypesFirestore currencyTypesFirestore = CurrencyTypesFirestore();
  AccountTypeFirestore accountTypeFirestore = AccountTypeFirestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 125.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let’s setup your account!",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Account can be your bank, credit card or your wallet.",
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(25.0),
              child: largestButton(
                text: "Let’s go",
                onPressed: () => RouteApplication.navigatorKey.currentState
                    ?.pushNamed(RouteApplication.getRoute(ERoute.setDefault),
                        arguments: [
                      (ModalAccountType? accountType,
                          ModalCurrencyType? currencyType,
                          double? balance) async {
                        DocumentReference accountTypeRef =
                            accountTypeFirestore.getRef(accountType!);
                        await AccountFirestore().insert(ModalAccount(
                            id: accountType.id,
                            accountTypeRef: accountTypeRef,
                            money: balance,
                            currencyTypeRef:
                                currencyTypesFirestore.getRef(currencyType!)));
                        List<ModalUser>? modals = await userFirestore.read();
                        if (modals != null && modals.isNotEmpty) {
                          ModalUser fieldUser = modals.first;
                          fieldUser.currencyTypeDefaultRef =
                              currencyTypesFirestore.getRef(currencyType);
                          fieldUser.wasSetup = true;
                          userFirestore.insert(fieldUser);
                        }

                        UserInstance.instance(renew: true);
                        TranasactionTypeInstance.instance(renew: true);
                        CurrencyTypeInstance.instance(renew: true);

                        RouteApplication.navigatorKey.currentState
                            ?.popUntil((route) => false);
                        RouteApplication.navigatorKey.currentState
                            ?.pushNamed(RouteApplication.getRoute(ERoute.main));
                      },
                    ]),
              ))
        ],
      ),
    );
  }
}
