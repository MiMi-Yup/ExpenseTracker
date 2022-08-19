import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/constant/enum/enum_category.dart';
import 'package:expense_tracker/instance/category_component.dart';
import 'package:expense_tracker/page/add_edit_transaction/modal_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemTransaction {
  ModalTransaction modal;

  ItemTransaction({required this.modal});

  GestureDetector builder(
      {void Function()? onTap,
      void Function()? editSlidableAction,
      void Function()? deleteSlidableAction}) {
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CategoryInstance.instances[modal.category]!()
                              .getFullCategory(height: 50.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CategoryInstance
                                      .instances[modal.category]!().name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  modal.description ?? "",
                                  style: TextStyle(color: Colors.white70),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            modal.getMoney,
                            style: TextStyle(
                                color: MyColor
                                    .colorTransaction[modal.typeTransaction]),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            modal.getTimeTransaction,
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ]),
              ),
            )));
  }
}
