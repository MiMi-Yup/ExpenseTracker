import 'package:expense_tracker/constant/enum/enum_category.dart';
import 'package:expense_tracker/constant/enum/enum_frequency.dart';
import 'package:expense_tracker/constant/enum/enum_transaction.dart';

class ModalTransaction {
  ECategory? category;
  String? description;
  String? purpose;
  double? money;
  DateTime? timeTransaction;
  ETypeTransaction? typeTransaction;
  List<String>? attachment;
  String? account;
  bool? isRepeat;
  EFrequency? frequency;
  DateTime? endAfter;
  String? currency;

  ModalTransaction({
    required this.category,
    required this.money,
    required this.timeTransaction,
    required this.typeTransaction,
    required this.isRepeat,
    required this.account,
    required this.purpose,
    required this.currency,
    this.description,
    this.attachment,
    this.frequency,
    this.endAfter,
  });

  ModalTransaction.minInit({required this.category});

  String get getTimeTransaction {
    if (timeTransaction != null) {
      int hour = timeTransaction!.hour;
      int minute = timeTransaction!.minute;
      bool isPM = hour >= 12;
      hour = hour > 12 ? hour - 12 : hour;

      return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute} ${isPM ? "PM" : "AM"}";
    }
    return "";
  }

  String get getDateTransaction => timeTransaction != null
      ? "${timeTransaction!.day}/${timeTransaction!.month}/${timeTransaction!.year}"
      : "";

  String get getMoney =>
      money != null ? "$currency${money!.toStringAsFixed(3)}" : "";
}
