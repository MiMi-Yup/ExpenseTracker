import 'package:flutter/material.dart';

class DropDown<T> {
  Key? key;
  List<T> items;
  T? choseValue;
  void Function(T?) onChanged;
  String hint;
  bool isExpanded;
  Color hintColor;
  Color itemColor;
  Color selectedColor;
  Color focusColor;
  Color arrowColor;

  DropDown(
      {this.key,
      required this.items,
      required this.choseValue,
      required this.onChanged,
      required this.hint,
      this.isExpanded = true,
      this.hintColor = Colors.grey,
      this.itemColor = Colors.white,
      this.selectedColor = Colors.white,
      this.focusColor = Colors.white,
      this.arrowColor = Colors.white});
  Widget builder() => StatefulBuilder(
      builder: (context, setState) => DropdownButton<T>(
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
            onChanged: (value) {
              onChanged(value);
              setState(() => choseValue = value);
            },
          ));
}
