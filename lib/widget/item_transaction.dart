import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

String _convertTimeOfDay(DateTime date) {
  return "${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute} ${date.hour >= 12 ? "PM" : "AM"}";
}

GestureDetector itemTransaction(
    {required String category,
    String? description,
    required double money,
    required DateTime timeTransaction,
    required bool isIncome,
    void Function()? onTap,
    void Function()? editSlidableAction,
    void Function()? deleteSlidableAction}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          decoration: BoxDecoration(
              color: Colors.white10, borderRadius: BorderRadius.circular(10.0)),
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
                        Container(
                          width: 50.0,
                          height: 50.0,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white),
                          child: AspectRatio(
                            child: Image.asset("asset/image/salary.png"),
                            aspectRatio: 1.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                description ?? "",
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
                          "\$${money.toStringAsFixed(3)}",
                          style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          _convertTimeOfDay(timeTransaction),
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ]),
            ),
          )));
}
