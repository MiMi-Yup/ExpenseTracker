import 'dart:collection';

import 'package:expense_tracker/constants/asset/background.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/screens/tab/filter_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:flutter/material.dart';

class DetailAccount extends StatefulWidget {
  const DetailAccount({super.key});

  @override
  State<DetailAccount> createState() => _DetailAccountState();
}

class _DetailAccountState extends State<DetailAccount> {
  final TransactionUtilities _serviceTransaction = TransactionUtilities();
  final FilterTransaction filterTransaction = FilterTransaction();
  late Object? arguments = ModalRoute.of(context)?.settings.arguments;
  late ModalAccount modal = arguments != null
      ? arguments as ModalAccount
      : throw ArgumentError("Required ModalAccount");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map<String, List<ModalTransaction>?>>(
      initialData: null,
      future: _serviceTransaction.getTransactionByAccount(modal),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<SplayTreeMap<String, List<ModalTransaction>?>>(
              initialData: null,
              future: filterTransaction.filterTransactionAccount(
                  map: snapshot.data!),
              builder: (context, snapshot) {
                List<Widget> widget = snapshot.hasData
                    ? snapshot.data!.entries.map((group) {
                        if (group.value!.isNotEmpty) {
                          return SliverPadding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            sliver: Section(
                                headerColor: MyColor.mainBackgroundColor,
                                titleColor: Colors.white,
                                title:
                                    "${group.key} (${group.value!.length}) transactions",
                                content: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    removeBottom:
                                        snapshot.data!.entries.last != group,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: group.value!
                                          .map(
                                            (modal) => TransactionComponent(
                                              modal: modal,
                                              isEditable: false,
                                              onTap: () async {
                                                await RouteApplication
                                                    .navigatorKey.currentState
                                                    ?.pushNamed(
                                                        RouteApplication
                                                            .getRoute(ERoute
                                                                .detailTransaction),
                                                        arguments: [
                                                      modal,
                                                      false,
                                                      true
                                                    ]);
                                                setState(() {});
                                              },
                                              editSlidableAction: (context) {
                                                RouteApplication
                                                    .navigatorKey.currentState
                                                    ?.pushNamed(
                                                        RouteApplication
                                                            .getRoute(ERoute
                                                                .addEditTransaction),
                                                        arguments: modal);
                                              },
                                              deleteSlidableAction:
                                                  (context) async {
                                                await _serviceTransaction
                                                    .delete(modal);
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ))).builder(),
                          );
                        } else {
                          return const SliverPadding(
                              padding: EdgeInsets.all(0));
                        }
                      }).toList()
                    : [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 4),
                            child: LinearProgressIndicator(),
                          ),
                        )
                      ];
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                        floating: true,
                        pinned: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.3,
                        leading: IconButton(
                            onPressed: () => RouteApplication
                                .navigatorKey.currentState
                                ?.pop(),
                            icon: Icon(Icons.arrow_back_ios)),
                        centerTitle: true,
                        actions: [
                          IconButton(onPressed: null, icon: Icon(Icons.edit))
                        ],
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
                    ...widget,
                  ],
                );
              });
        } else {
          return LinearProgressIndicator();
        }
      },
    ));
  }
}
