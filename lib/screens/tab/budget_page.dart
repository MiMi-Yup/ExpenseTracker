import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/widgets/component/budget_component.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  bool hasData = true;
  int lengthListView = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: MyColor.mainBackgroundColor,
          leading:
              IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(onPressed: null, icon: Icon(Icons.arrow_forward_ios))
          ],
          title: Text("Month"),
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
                  child: hasData
                      ? MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: AnimatedList(
                              shrinkWrap: true,
                              initialItemCount: lengthListView,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index, animation) {
                                ModalBudget modal = ModalBudget(
                                    budgetMoney: 0.0,
                                    nowMoney: 0.0,
                                    isLimited: false,
                                    category: ECategory.shopping,
                                    currency: '\$');
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: BudgetComponent(modal: modal).builder(
                                    width: MediaQuery.of(context).size.width,
                                    onTap: null,
                                    editSlidableAction: null,
                                    deleteSlidableAction: (context) {
                                      lengthListView -= 1;
                                      AnimatedList.of(context).removeItem(
                                          index,
                                          (_, animation) => SizeTransition(
                                                sizeFactor: animation,
                                                child: BudgetComponent(
                                                        modal: modal)
                                                    .builder(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width),
                                              ),
                                          duration: const Duration(seconds: 1));
                                    },
                                  ),
                                );
                              }))
                      : Center(
                          child: Text(
                          "You don't have a budget",
                          style: TextStyle(color: Colors.black),
                        ))),
              SizedBox(
                  width: double.maxFinite,
                  child: largestButton(
                      text: "Create a budget", onPressed: () => null))
            ],
          ),
        ))
      ],
    );
  }
}
