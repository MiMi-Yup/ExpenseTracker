import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/budget.dart';
import 'package:expense_tracker/widgets/component/budget_component.dart';
import 'package:expense_tracker/widgets/component/fliter_month_component.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>
    with AutomaticKeepAliveClientMixin {
  final BudgetUtilities service = BudgetUtilities();

  DateTime? filterBudgetByMonth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: MyColor.mainBackgroundColor,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Show budget in month: '),
            FilterBudgetByMonthComponent(
                    onChanged: (value) {
                      setState(() {
                        filterBudgetByMonth = value;
                      });
                      RouteApplication.navigatorKey.currentState?.pop();
                    },
                    setInitDateTime: filterBudgetByMonth == null
                        ? (value) => filterBudgetByMonth = value
                        : null,
                    selectedDate: filterBudgetByMonth)
                .builder()
          ]),
          centerTitle: true,
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(16.0),
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0))),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot<ModalBudget>>(
                stream: BudgetFirestore().stream,
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Iterable<ModalBudget> data =
                        snapshot.data!.docs.map((e) => e.data());
                    if (data.isEmpty) {
                      return Center(
                          child: Text(
                        "You don't have a budget",
                      ));
                    } else {
                      return SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                              children: data
                                  .map((modal) => BudgetComponent(
                                      modal: modal,
                                      nowMoney: 550.0,
                                      onTap: () => RouteApplication
                                          .navigatorKey.currentState
                                          ?.pushNamed(
                                              RouteApplication.getRoute(
                                                  ERoute.addEditBudget),
                                              arguments: modal),
                                      editSlidableAction: (context) =>
                                          RouteApplication
                                              .navigatorKey.currentState
                                              ?.pushNamed(
                                                  RouteApplication.getRoute(
                                                      ERoute.addEditBudget),
                                                  arguments: modal),
                                      deleteSlidableAction: (context) async {
                                        await service.delete(modal);
                                      }))
                                  .toList()));
                    }
                  }
                  return Center(child: Text("Wait for loading"));
                },
              )),
              Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: largestButton(
                      text: "Create a budget",
                      onPressed: () =>
                          RouteApplication.navigatorKey.currentState?.pushNamed(
                              RouteApplication.getRoute(ERoute.addEditBudget))))
            ],
          ),
        ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
