import 'package:expense_tracker/constant/enum/enum_category.dart';
import 'package:expense_tracker/constant/enum/enum_frequency.dart';
import 'package:expense_tracker/constant/enum/enum_transaction.dart';

class ModalTransaction {
  ECategory category;
  String? description;
  String purpose;
  double money;
  DateTime timeTransaction;
  ETypeTransaction typeTransaction;
  String? attachment;
  String account;
  bool isRepeat;
  EFrequency? frequency;
  DateTime? endAfter;
  String currency;

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

  String get getTimeTransaction {
    int hour = timeTransaction.hour;
    int minute = timeTransaction.minute;
    bool isPM = hour >= 12;
    hour = hour > 12 ? hour - 12 : hour;

    return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute} ${isPM ? "PM" : "AM"}";
  }

  String get getDateTransaction =>
      "${timeTransaction.day}/${timeTransaction.month}/${timeTransaction.year}";

  String get getMoney => "$currency${money.toStringAsFixed(3)}";
}
