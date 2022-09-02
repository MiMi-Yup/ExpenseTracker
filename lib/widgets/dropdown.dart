import 'package:flutter/material.dart';

class DropDown<T> extends DropdownButton<T> {
  DropDown(
      {Key? key,
      required List<T> items,
      required T? choseValue,
      required void Function(T?) onChanged,
      required String hint,
      bool isExpanded = true,
      Color hintColor = Colors.grey,
      Color itemColor = Colors.white,
      Color selectedColor = Colors.white,
      Color focusColor = Colors.white,
      Color arrowColor = Colors.white})
      : super(
          key: key, isExpanded: isExpanded,
          focusColor: focusColor,
          value: choseValue,
          underline: const SizedBox(),
          borderRadius: BorderRadius.circular(10.0),
          //elevation: 5,
          style: TextStyle(color: selectedColor),
          icon: Icon(Icons.keyboard_arrow_down, color: arrowColor),
          items: items
              .map<DropdownMenuItem<T>>((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: TextStyle(color: itemColor),
                    ),
                  ))
              .toList(),
          hint: Text(
            hint.toString(),
            style: TextStyle(
                color: hintColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          onChanged: onChanged,
        );
}
