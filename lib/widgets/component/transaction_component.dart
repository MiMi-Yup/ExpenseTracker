import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/instances/category_component.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionComponent {
  ModalTransaction modal;

  TransactionComponent({required this.modal});

  GestureDetector builder(
      {required bool isEditable,
      void Function()? onTap,
      void Function(BuildContext)? editSlidableAction,
      void Function(BuildContext)? deleteSlidableAction}) {
    final content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    CategoryInstance.instances[modal.category]!().name,
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
                  color: MyColor.colorTransaction[modal.typeTransaction]),
            ),
            SizedBox(height: 10.0),
            Text(
              modal.getTimeTransaction,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ]),
    );
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10.0)),
            child: isEditable
                ? Slidable(
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
                    child: content,
                  )
                : content));
  }
}
