import 'package:flutter/material.dart';

StatefulBuilder dropDown(
    {required List<String> items, required void Function(String?) onChanged}) {
  String? _chosenValue;
  return StatefulBuilder(
      builder: (context, setState) => DropdownButton<String>(
            focusColor: Colors.white,
            value: _chosenValue,
            underline: SizedBox(),
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            icon: Icon(Icons.keyboard_arrow_down),
            items: items
                .map<DropdownMenuItem<String>>(
                    (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                .toList(),
            hint: Text(
              "Please choose a langauage",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            onChanged: (value) {
              setState(() => _chosenValue = value ?? "");
              onChanged(value);
            },
          ));
}
