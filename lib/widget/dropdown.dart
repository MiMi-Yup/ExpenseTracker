import 'package:flutter/material.dart';

DropdownButton<String> dropDown(
    {required List<String> items,
    required String? chosenValue,
    required void Function(String?) onChanged,
    Color hintColor = Colors.grey,
    Color itemColor = Colors.white,
    Color selectedColor = Colors.white,
    Color focusColor = Colors.white,
    Color arrowColor = Colors.white}) {
  return DropdownButton<String>(
    isExpanded: true,
    focusColor: focusColor,
    value: chosenValue,
    underline: const SizedBox(),
    //elevation: 5,
    style: TextStyle(color: selectedColor),
    icon: Icon(Icons.keyboard_arrow_down, color: arrowColor),
    items: items
        .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(color: itemColor),
              ),
            ))
        .toList(),
    hint: Text(
      "Please choose",
      style: TextStyle(
          color: hintColor, fontSize: 14, fontWeight: FontWeight.w500),
    ),
    onChanged: (value) => onChanged(value),
  );
}
