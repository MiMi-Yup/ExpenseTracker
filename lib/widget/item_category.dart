import 'package:flutter/material.dart';

class CategoryWidget {
  String name;
  Color backgroundColor;
  String assetContainer;
  double heightForFull;
  double heightForMin;
  CategoryWidget(
      {required this.name,
      required this.backgroundColor,
      required this.assetContainer,
      this.heightForFull = 50.0,
      this.heightForMin = 10.0});

  Widget getFullCategory() => Container(
        width: heightForFull,
        height: heightForFull,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: backgroundColor),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Image.asset(assetContainer),
        ),
      );

  Widget getMinCategory() => Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(heightForMin * 2),
            border: Border.all(color: backgroundColor)),
        child: Row(
          children: [
            Container(
              height: heightForMin,
              width: heightForMin,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                  color: backgroundColor.withAlpha(255),
                  shape: BoxShape.circle),
            ),
            Text(name)
          ],
        ),
      );
}

Widget itemCategory() {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), color: Colors.white),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.orange),
          child: Image.asset("asset/image/city_bank.png"),
        ),
        Text("City Bank", style: TextStyle(color: Colors.black))
      ],
    ),
  );
}

Widget itemCategoryPercent(
    {required double width,
    required double percent,
    Color backgroundIndicatorColor = Colors.grey,
    Color indicatorColor = Colors.orange,
    Color valueColor = Colors.red,
    String? category,
    String? value}) {
  const height = 10.0;
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height * 2),
                  border: Border.all(color: backgroundIndicatorColor)),
              child: Row(
                children: [
                  Container(
                    height: height,
                    width: height,
                    margin: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        color: indicatorColor, shape: BoxShape.circle),
                  ),
                  Text("Shopping")
                ],
              ),
            ),
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
                  color: indicatorColor),
            )
          ],
        )
      ],
    ),
  );
}
