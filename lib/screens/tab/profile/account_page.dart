import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/asset/background.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/currency_type_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/currency_types.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:expense_tracker/widgets/component/account_component.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserFirestore userFirestore = UserFirestore();
  CurrencyTypesFirestore currencyTypesFirestore = CurrencyTypesFirestore();
  AccountTypeFirestore accountTypeFirestore = AccountTypeFirestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: FutureBuilder<List<ModalAccount>?>(
            future: AccountFirestore().read(),
            builder: (context, snapshot) {
              Widget widget = snapshot.hasData
                  ? SliverList(
                      delegate: SliverChildListDelegate(
                          snapshot.data!
                              .map((e) => AccountComponent(
                                  accountModal: e,
                                  onTap: () async {
                                    await RouteApplication
                                        .navigatorKey.currentState
                                        ?.pushNamed(
                                            RouteApplication.getRoute(
                                                ERoute.detailAccount),
                                            arguments: e);
                                    setState(() {});
                                  }))
                              .toList(),
                          addSemanticIndexes: false))
                  : SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 4),
                        child: LinearProgressIndicator(),
                      ),
                    );
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                      floating: true,
                      pinned: true,
                      expandedHeight: MediaQuery.of(context).size.height * 0.3,
                      leading: IconButton(
                          onPressed: () =>
                              RouteApplication.navigatorKey.currentState?.pop(),
                          icon: Icon(Icons.arrow_back_ios)),
                      centerTitle: true,
                      backgroundColor: MyColor.mainBackgroundColor,
                      elevation: 0.0,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Image.asset(
                            BackgroundAsset.walletBackground,
                            isAntiAlias: true,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Wallet Balance",
                                  style: TextStyle(fontSize: 30)),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text("\$6400", style: TextStyle(fontSize: 16))
                            ],
                          )
                        ],
                      ))),
                  widget
                ],
              );
            },
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16.0),
          child: largestButton(
              text: "+ Add new wallet",
              onPressed: () async {
                await RouteApplication.navigatorKey.currentState?.pushNamed(
                    RouteApplication.getRoute(ERoute.addEditAccount),
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

                        CurrencyTypeInstance.instance(renew: true);

                        RouteApplication.navigatorKey.currentState?.popUntil(
                            ModalRoute.withName(RouteApplication.getRoute(
                                ERoute.overviewAccount)));
                      }
                    ]);
                setState(() {});
              }),
        )
      ],
    ));
  }
}
