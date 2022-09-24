import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/budget.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddEditBudget extends StatefulWidget {
  const AddEditBudget({Key? key}) : super(key: key);

  @override
  State<AddEditBudget> createState() => _AddEditBudgetState();
}

class _AddEditBudgetState extends State<AddEditBudget> {
  bool _isAlert = false;

  final BudgetUtilities service = BudgetUtilities();

  late Object? argument = ModalRoute.of(context)?.settings.arguments;
  late ModalBudget modal = argument != null
      ? argument as ModalBudget
      : ModalBudget(
          id: null,
          budget: null,
          percentAlert: null,
          timeCreate: null,
          categoryTypeRef: null);

  late ModalCategoryType? choseCategoryType = modal.categoryTypeRef != null
      ? CategoryInstance.instance().getModal(modal.categoryTypeRef!.id)
      : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () =>
                  RouteApplication.navigatorKey.currentState?.pop(),
              icon: Icon(Icons.arrow_back_ios)),
          elevation: 0,
          backgroundColor: MyColor.mainBackgroundColor,
          title: Text("Budget"),
          centerTitle: true,
        ),
        bottomSheet: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "How much do you want to spend?",
                  style: TextStyle(fontSize: 25.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 40.0),
                    decoration: InputDecoration(
                        prefixText:
                            "${UserInstance.instance().getCurrency()?.currencyCode} ",
                        isCollapsed: true,
                        hintText: "0.00",
                        border: InputBorder.none),
                    onChanged: (value) => modal.budget = double.tryParse(value),
                    controller:
                        TextEditingController(text: "${modal.budget ?? ""}")),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<List<ModalCategoryType>>(
                      future: CategoryTypeFirebase().read(),
                      initialData: [],
                      builder: (context, snapshot) =>
                          DropDown<ModalCategoryType>(
                              hint: "Choose category",
                              items: snapshot.data!,
                              choseValue: choseCategoryType,
                              onChanged: (value) =>
                                  choseCategoryType = value).builder(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Receive Alert",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              "Receive alert when it reaches",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ],
                        ),
                        Switch(
                            value: _isAlert,
                            onChanged: (value) => setState(() {
                                  modal.percentAlert = value == false
                                      ? null
                                      : modal.percentAlert;
                                  _isAlert = value;
                                }))
                      ],
                    ),
                    Visibility(
                        visible: _isAlert,
                        child: Row(
                          children: [
                            Expanded(
                                child: Slider(
                                    value: modal.percent,
                                    onChanged: (value) => setState(() =>
                                        modal.percentAlert =
                                            value > 0.0 ? value : null))),
                            Text(
                              "${(modal.percent * 100.0).round()}%",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        )),
                    SizedBox(
                      width: double.maxFinite,
                      child: largestButton(
                          text: "Continue",
                          onPressed: () async {
                            if (modal.budget == null ||
                                modal.budget! <= 0 ||
                                choseCategoryType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please fill full')));
                            } else {
                              modal.categoryTypeRef = CategoryTypeFirebase()
                                  .getRef(choseCategoryType!);
                              modal.timeCreate = Timestamp.now();

                              dynamic result = await service.add(modal);
                              if (argument is ModalBudget &&
                                  result is ModalBudget) {
                                await BudgetFirestore().update(result, modal);
                                dismissPage();
                              } else if (result is ModalBudget) {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0))),
                                    context: context,
                                    builder: (context) => Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Exist budget",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    "1 month allow exist only 1 budget for 1 category. What do you want?"),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => RouteApplication
                                                          .navigatorKey
                                                          .currentState
                                                          ?.popUntil(ModalRoute
                                                              .withName(
                                                                  RouteApplication
                                                                      .getRoute(
                                                                          ERoute
                                                                              .main))),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: MyColor
                                                                .purple()),
                                                        child: Text("Dismiss"),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await service
                                                            .delete(result);
                                                        await service
                                                            .add(modal);
                                                        dismissPage();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color:
                                                                MyColor.purple(
                                                                    alpha:
                                                                        125)),
                                                        child: Text("Override"),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        RouteApplication
                                                            .navigatorKey
                                                            .currentState
                                                            ?.popUntil(ModalRoute.withName(
                                                                RouteApplication
                                                                    .getRoute(ERoute
                                                                        .main)));
                                                        RouteApplication
                                                            .navigatorKey
                                                            .currentState
                                                            ?.pushNamed(
                                                                RouteApplication
                                                                    .getRoute(ERoute
                                                                        .addEditBudget),
                                                                arguments:
                                                                    result);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color:
                                                                MyColor.purple(
                                                                    alpha:
                                                                        125)),
                                                        child: Text(
                                                            "Edit current budget"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                              } else {
                                dismissPage();
                              }
                            }
                          }),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<void> dismissPage() {
    return Future.delayed(
        const Duration(seconds: 1),
        () => RouteApplication.navigatorKey.currentState?.popUntil(
            ModalRoute.withName(RouteApplication.getRoute(ERoute.main))));
  }
}
