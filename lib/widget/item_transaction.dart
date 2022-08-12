import 'package:flutter/material.dart';

GestureDetector itemTransaction({void Function()? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white),
                  child: Image.asset("asset/image/mandiri_bank.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: [
                      Text(
                        "data",
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "data",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "data",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 10.0),
                Text(
                  "data",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ]),
        ),
      ));
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
