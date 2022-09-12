import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class MonthPickerStateful {
  void Function(DateTime)? onChanged;
  Key? key;
  DateTime startDate;
  DateTime lastDate;
  DateTime? selectedDate;

  MonthPickerStateful(
      {this.key,
      required this.onChanged,
      required this.startDate,
      required this.lastDate,
      this.selectedDate}) {
    selectedDate ??= lastDate;
  }

  Widget builder() => StatefulBuilder(builder: (context, setState) {
        return MonthPicker.single(
            selectedDate: selectedDate!,
            onChanged: (value) {
              setState(() => selectedDate = value);
              if (onChanged != null) onChanged!(value);
            },
            firstDate: startDate,
            lastDate: lastDate);
      });
}
