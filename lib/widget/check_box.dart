import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

StatefulBuilder checkBox(
    {required bool? initStateChecked,
    required void Function(bool?) onChanged,
    String? text,
    Widget? action}) {
  bool _value = initStateChecked ?? false;
  return StatefulBuilder(
      builder: (context, setState) => Row(
            children: [
              Checkbox(
                  value: _value,
                  onChanged: (value) => setState(() {
                        onChanged(value);
                        _value = value ?? false;
                      })),
              Text(text ?? ""),
              action ?? Container()
            ],
          ));
}
