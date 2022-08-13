import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget itemBudget(
    {required double width,
    required double percent,
    Color backgroundIndicatorColor = Colors.grey,
    Color indicatorColor = Colors.orange,
    Color valueColor = Colors.red,
    String? category,
    String? value}) {
  const height = 10.0;
  return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(10.0)),
      child: Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                  // An action can be bigger than the others.
                  onPressed: (context) => null,
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              SlidableAction(
                  onPressed: (context) => null,
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
                    Visibility(
                      child: Icon(Icons.warning_amber),
                      visible: true,
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Text("Remaining \$0"),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Stack(
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
                  ),
                ),
                Text(
                  "\$1200 of \$1000",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10.0),
                Visibility(
                    child: Text(
                  "You're exceed the limit!",
                  style: TextStyle(color: Colors.red),
                ))
              ],
            ),
          )));
}
