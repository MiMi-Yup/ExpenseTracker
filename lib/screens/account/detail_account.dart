import 'dart:collection';
import 'dart:typed_data';

import 'package:expense_tracker/constants/asset/background.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/currency_type_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/screens/tab/filter_transaction.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/overview_transaction_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
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
  final TransactionUtilities serviceTransaction = TransactionUtilities();

  late Object? arguments = ModalRoute.of(context)?.settings.arguments;
  late ModalAccount modal = arguments != null
      ? arguments as ModalAccount
      : throw ArgumentError("Required ModalAccount");

  late ModalAccountType? accountTypeModal =
      AccountTypeInstance.instance().getModal(modal.accountTypeRef!.id);

  List<Widget> getOverviewTransaction(
      Map<String, List<ModalTransaction>?> map) {
    List<ModalTransaction> modals = [];
    for (List<ModalTransaction>? element in map.values) {
      if (element != null) {
        modals.addAll(element);
      }
    }

    Map<ModalTransactionType, List<ModalTransaction>?>
        mappingByModalTransactionType = {};
    for (ModalTransaction element in modals) {
      ModalTransactionType? transactionTypeModal =
          TranasactionTypeInstance.instance()
              .getModal(element.transactionTypeRef!.id);
      if (transactionTypeModal != null) {
        if (mappingByModalTransactionType.containsKey(transactionTypeModal)) {
          mappingByModalTransactionType[transactionTypeModal]?.add(element);
        } else {
          mappingByModalTransactionType.addAll({
            transactionTypeModal: [element]
          });
        }
      }
    }

    return mappingByModalTransactionType.keys.map((modalType) {
      double totalMoney = 0.0;
      mappingByModalTransactionType[modalType]?.forEach(
          (modalTransaction) => totalMoney += modalTransaction.money ?? 0.0);
      return OverviewTransactionComponent(
              modal: modalType,
              money: totalMoney,
              currency: CurrencyTypeInstance.instance()
                  .getModal(modal.currencyTypeRef!.id))
          .builder();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width / 4),
                              child: LinearProgressIndicator(),
                            ),
                          );
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
                  physics: ClampingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                        floating: true,
                        pinned: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.35,
                        leading: IconButton(
                            onPressed: () => RouteApplication
                                .navigatorKey.currentState
                                ?.pop(),
                            icon: Icon(Icons.arrow_back_ios)),
                        centerTitle: true,
                        actions: [
                          IconButton(
                              onPressed: () => RouteApplication
                                      .navigatorKey.currentState
                                      ?.pushNamed(
                                          RouteApplication.getRoute(
                                              ERoute.addEditAccount),
                                          arguments: [
                                        (ModalAccountType? accountType,
                                            ModalCurrencyType? currencyType,
                                            double? balance) async {},
                                        modal
                                      ]),
                              icon: Icon(Icons.edit)),
                          if (snapshot.hasData && snapshot.data!.isEmpty)
                            IconButton(
                                onPressed: () {
                                  AccountFirestore().delete(modal).then((_) =>
                                      RouteApplication.navigatorKey.currentState
                                          ?.pop());
                                },
                                icon: Icon(Icons.delete_forever))
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
                                SizedBox(
                                  height: size.width / 4,
                                  width: size.width / 4,
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: accountTypeModal?.color
                                              ?.withAlpha(25),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      alignment: Alignment.center,
                                      child: accountTypeModal?.localAsset ==
                                              true
                                          ? Image.asset(
                                              accountTypeModal!.image!,
                                              fit: BoxFit.scaleDown,
                                            )
                                          : FutureBuilder<Uint8List?>(
                                              future: ActionFirebaseStorage
                                                  .downloadFile(
                                                      accountTypeModal!.image!),
                                              builder: (context, snapshot) =>
                                                  snapshot.hasData
                                                      ? Image.memory(
                                                          snapshot.data!)
                                                      : LinearProgressIndicator()),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "${accountTypeModal?.name}",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                if (snapshot.hasData)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        getOverviewTransaction(snapshot.data!),
                                  )
                                else
                                  LinearProgressIndicator()
                              ],
                            )
                          ],
                        ))),
                    ...widget
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
