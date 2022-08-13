import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

GestureDetector itemTransaction({void Function()? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
          )));
}
