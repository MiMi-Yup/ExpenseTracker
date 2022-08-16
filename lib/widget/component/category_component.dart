import 'package:flutter/material.dart';

class CategoryComponent {
  String name;
  Color backgroundColor;
  String assetName;
  Color? assetColor;
  CategoryComponent(
      {required this.name,
      required this.backgroundColor,
      required this.assetName,
      this.assetColor});

  Widget getFullCategory({double height = 50.0}) => Container(
        width: height,
        height: height,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: backgroundColor),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Image.asset(
            assetName,
            color: assetColor,
          ),
        ),
      );

  Widget getMinCategory({double height = 10.0, Color? indicatorColor}) =>
      Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 2),
            border: Border.all(color: backgroundColor)),
        child: Row(
          children: [
            Container(
              height: height,
              width: height,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                  color: indicatorColor ?? assetColor, shape: BoxShape.circle),
            ),
            Text(name)
          ],
        ),
      );
}
