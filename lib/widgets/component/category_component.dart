import 'package:expense_tracker/instances/category_component.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:flutter/material.dart';

class CategoryComponent {
  ModalBudget modal;

  CategoryComponent({required this.modal});

  Widget nameCategoryBuilder() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CategoryInstance.instances[modal.category]!()
          //     .getFullCategory(height: 50.0),
          // Text(CategoryInstance.instances[modal.category]!().name,
          //     style: TextStyle(color: Colors.black))
        ],
      ),
    );
  }

  Widget percentCategoryBuilder(
      {required double width,
      Color backgroundIndicatorColor = Colors.grey,
      Color valueColor = Colors.red}) {
    const height = 10.0;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CategoryInstance.instances[modal.category]!()
              //     .getMinCategory(height: 10.0),
              // Text(
              //   "${modal.currency}${modal.nowMoney}",
              //   style: TextStyle(color: valueColor),
              // )
            ],
          ),
          SizedBox(height: 10.0),
          Stack(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 2),
                    color: backgroundIndicatorColor),
              ),
              // Container(
              //   width: width * modal.percent,
              //   height: height,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(height * 2),
              //       color: CategoryInstance
              //           .instances[modal.category]!().assetColor),
              // )
            ],
          )
        ],
      ),
    );
  }
}
