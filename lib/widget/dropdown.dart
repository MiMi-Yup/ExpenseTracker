import 'package:flutter/material.dart';

DropdownButton<String> dropDown(
    {required List<String> items,
    required String? chosenValue,
    required void Function(String?) onChanged}) {
  return DropdownButton<String>(
    focusColor: Colors.white,
    value: chosenValue,
    underline: SizedBox(),
    //elevation: 5,
    style: TextStyle(color: Colors.white),
    icon: Icon(Icons.keyboard_arrow_down),
    items: items
        .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(color: Colors.white),
              ),
            ))
        .toList(),
    hint: Text(
      "Please choose",
      style: TextStyle(
          color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
    ),
    onChanged: (value) => onChanged(value),
  );
}
