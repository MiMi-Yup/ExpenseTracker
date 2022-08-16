import 'package:expense_tracker/instance/category_component.dart';
import 'package:flutter/material.dart';

Widget itemCategory({required ECategory category}) {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), color: Colors.white),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CategoryInstance.instances[category]!().getFullCategory(height: 50.0),
        Text(CategoryInstance.instances[category]!().name,
            style: TextStyle(color: Colors.black))
      ],
    ),
  );
}

Widget itemCategoryPercent(
    {required double width,
    required double percent,
    required ECategory category,
    Color backgroundIndicatorColor = Colors.grey,
    Color valueColor = Colors.red,
    String? value}) {
  const height = 10.0;
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryInstance.instances[category]!()
                .getMinCategory(height: 10.0),
            Text(
              "-\$120",
              style: TextStyle(color: valueColor),
            )
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
              width: width * percent,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height * 2),
                  color: CategoryInstance.instances[category]!().assetColor),
            )
          ],
        )
      ],
    ),
  );
}
