import 'package:expense_tracker/instance/category_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ModalItemBudget {
  double budgetMoney;
  double nowMoney;
  bool isLimited;
  ECategory category;

  double get remainMoney {
    double _sub = budgetMoney - nowMoney;
    return _sub < 0 ? 0 : _sub;
  }

  double get percent {
    if (budgetMoney == 0) return 1;
    double _percent = nowMoney / budgetMoney;
    return _percent > 1 ? 1 : _percent;
  }

  bool get isExceedLimit => isLimited && (nowMoney - budgetMoney) > 0;

  ModalItemBudget(
      {required this.budgetMoney,
      required this.nowMoney,
      this.isLimited = false,
      required this.category});
}

class ItemBudget {
  ModalItemBudget modal;

  ItemBudget({required this.modal});

  Widget builder({
    required double width,
    void Function()? onTap,
    void Function()? editSlidableAction,
    void Function()? deleteSlidableAction,
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
                        onPressed: (context) => editSlidableAction,
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    SlidableAction(
                        onPressed: (context) => deleteSlidableAction,
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
                      Text("Remaining \${currency}${modal.remainMoney}"),
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
                        "\${currency}${modal.nowMoney} of \${currency}${modal.budgetMoney}",
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
