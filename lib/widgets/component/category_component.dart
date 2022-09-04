import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
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
          CategoryInstance.instance()
              .getHintCategoryComponent(modal.categoryTypeRef!.id)
              .getFullCategory(),
          Text(
              '${CategoryInstance.instance().getModal(modal.categoryTypeRef!.id)?.name}',
              style: TextStyle(color: Colors.black))
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
              CategoryInstance.instance()
                  .getHintCategoryComponent(modal.categoryTypeRef!.id)
                  .getMinCategory(),
              Text(
                  //now money query missing
                  '${UserInstance.instance().getCurrency().currencyCode} ${modal.budget}',
                  style: TextStyle(color: valueColor))
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
              Container(
                width: width * modal.percent,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 2),
                    color: CategoryInstance.instance()
                        .getModal(modal.categoryTypeRef!.id)
                        ?.color),
              )
            ],
          )
        ],
      ),
    );
  }
}
