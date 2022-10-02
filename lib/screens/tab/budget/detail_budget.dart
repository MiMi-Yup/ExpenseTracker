import 'dart:async';

import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/category_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/budget.dart';
import 'package:expense_tracker/widgets/component/hint_category_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:flutter/material.dart';

class DetailBudget extends StatefulWidget {
  const DetailBudget({super.key});

  @override
  State<DetailBudget> createState() => _DetailBudgetState();
}

class _DetailBudgetState extends State<DetailBudget> {
  late Object? arguments = ModalRoute.of(context)?.settings.arguments;
  late ModalBudget modal = arguments is ModalBudget
      ? arguments as ModalBudget
      : throw ArgumentError('Require argument ModalBudget');

  final BudgetUtilities serviceBudget = BudgetUtilities();

  final StreamController<double> _streamController = StreamController<double>();

  List<ModalTransaction>? storeLastLoad;

  void calTotalMoney(List<ModalTransaction>? modals) async {
    if (modals != null) {
      double totalMoney = 0.0;
      modals.forEach((element) => totalMoney += element.money ?? 0.0);
      _streamController.sink.add(totalMoney);
    }
  }

  String convertDMY(DateTime date) => "${date.day}/${date.month}/${date.year}";

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeCreate = modal.getTimeCreate!;
    DateTime startDate = DateTime(timeCreate.year, timeCreate.month, 1);
    DateTime endDate = DateTime(timeCreate.year, timeCreate.month + 1, 0);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => RouteApplication.navigatorKey.currentState?.pop(),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('Detail Budget'),
        actions: [
          IconButton(
              onPressed: () => RouteApplication.navigatorKey.currentState
                  ?.pushNamed(RouteApplication.getRoute(ERoute.addEditBudget),
                      arguments: modal),
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                await serviceBudget.delete(modal);
                RouteApplication.navigatorKey.currentState?.popUntil(
                    ModalRoute.withName(
                        RouteApplication.getRoute(ERoute.main)));
              },
              icon: Icon(Icons.delete_forever))
        ],
        elevation: 0.0,
        backgroundColor: MyColor.mainBackgroundColor,
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time of budget: ", style: TextStyle(fontSize: 18.0)),
                    Row(
                      children: [
                        Text(convertDMY(startDate),
                            style: TextStyle(fontSize: 18.0)),
                        Text("-"),
                        Text(convertDMY(endDate),
                            style: TextStyle(fontSize: 18.0))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category: ", style: TextStyle(fontSize: 18.0)),
                    HintCategoryComponent(
                            modal: CategoryTypeInstance.instance()
                                .getModal(modal.categoryTypeRef!.id)!)
                        .getMinCategory(),
                  ],
                ),
              ),
              Container(
                height: 50.0,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Budget:", style: TextStyle(fontSize: 18.0)),
                    Text(
                        "${UserInstance.instance().defaultCurrencyAccount?.currencyCode} ${modal.budget.toString()}",
                        style: TextStyle(fontSize: 18.0))
                  ],
                ),
              ),
              StreamBuilder<double>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50.0,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Now expense:",
                                    style: TextStyle(fontSize: 18.0)),
                                Text(
                                    snapshot.data != null
                                        ? "${UserInstance.instance().defaultCurrencyAccount?.currencyCode} ${snapshot.data}"
                                        : "Loading",
                                    style: TextStyle(fontSize: 18.0))
                              ],
                            ),
                          ),
                          Container(
                            height: 50.0,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Percent expense:",
                                    style: TextStyle(fontSize: 18.0)),
                                Text(
                                    "${snapshot.data != null ? "${(snapshot.data! / modal.budget! * 100.0).toStringAsFixed(2)}%" : "Loading"}",
                                    style: TextStyle(fontSize: 18.0))
                              ],
                            ),
                          )
                        ],
                      )),
            ],
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        constraints: BoxConstraints(maxHeight: size.height / 2),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: FutureBuilder<List<ModalTransaction>>(
          future: serviceBudget.getTransactionsInBudget(modal),
          initialData: storeLastLoad,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                List<ModalTransaction>? modals = snapshot.data;
                calTotalMoney(modals);
                if (modals != null) {
                  storeLastLoad = modals;
                  modals.sort((modal1, modal2) =>
                      (modal2.money! - modal1.money!).toInt());
                  return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        shrinkWrap: true,
                        children: modals
                            .map((e) => TransactionComponent(
                                  modal: e,
                                  isEditable: false,
                                  onTap: () async => await RouteApplication
                                      .navigatorKey.currentState
                                      ?.pushNamed(
                                          RouteApplication.getRoute(
                                              ERoute.detailTransaction),
                                          arguments: [e, false, true]),
                                ))
                            .toList(),
                      ));
                } else {
                  return const Center(child: Text("Empty list transaction"));
                }
              default:
                return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
