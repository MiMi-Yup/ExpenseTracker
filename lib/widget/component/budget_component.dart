import 'package:expense_tracker/instance/category_component.dart';
import 'package:expense_tracker/page/modal/modal_budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BudgetComponent {
  ModalBudget modal;

  BudgetComponent({required this.modal});

  Widget builder({
    required double width,
    void Function()? onTap,
    void Function(BuildContext)? editSlidableAction,
    void Function(BuildContext)? deleteSlidableAction,
    Color backgroundIndicatorColor = Colors.grey,
    Color indicatorColor = Colors.orange,
    Color valueColor = Colors.red,
  }) {
    const height = 10.0;
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10.0)),
            child: Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                        // An action can be bigger than the others.
                        onPressed: editSlidableAction,
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    SlidableAction(
                        onPressed: deleteSlidableAction,
                        backgroundColor: Color(0xFF0392CF),
                        foregroundColor: Colors.white,
                        icon: Icons.delete_forever,
                        label: 'Delete',
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryInstance.instances[modal.category]!()
                              .getMinCategory(
                                  height: 10.0, indicatorColor: Colors.orange),
                          Visibility(
                            child: Icon(Icons.warning_amber),
                            visible: true,
                          )
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text("Remaining ${modal.currency}${modal.remainMoney}"),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Stack(
                          children: [
                            Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height * 2),
                                  color: backgroundIndicatorColor),
                            ),
                            Container(
                              width: width * modal.percent,
                              height: height,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height * 2),
                                  color: indicatorColor),
                            )
                          ],
                        ),
                      ),
                      Text(
                        "${modal.currency}${modal.nowMoney} ${modal.isLimited ? "of ${modal.currency}${modal.budgetMoney}" : ""}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10.0),
                      Visibility(
                          visible: modal.isExceedLimit,
                          child: Text(
                            "You're exceed the limit!",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ))));
  }
}
