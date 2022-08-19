import 'dart:ui';

import 'package:expense_tracker/constant/enum/enum_transaction.dart';
import 'package:flutter/material.dart';

class MyColor {
  static Color purple({int? alpha}) =>
      Color.fromARGB(alpha ?? 255, 127, 61, 255);
  static Color mainBackgroundColor = const Color.fromARGB(255, 48, 48, 48);
  static Color purpleTranparent = const Color.fromARGB(255, 238, 229, 255);

  static const Map<ETypeTransaction, Color?> colorTransaction =
      <ETypeTransaction, Color?>{
    ETypeTransaction.income: Colors.red,
    ETypeTransaction.expense: Colors.green
  };
}
