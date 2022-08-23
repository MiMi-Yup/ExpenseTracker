import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/constants/enum/enum_frequency.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';

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

  ModalTransaction.minInit({required this.typeTransaction});

  ModalTransaction.clone(ModalTransaction clone) {
    category = clone.category;
    money = clone.money;
    timeTransaction = clone.timeTransaction;
    typeTransaction = clone.typeTransaction;
    isRepeat = clone.isRepeat;
    account = clone.account;
    purpose = clone.purpose;
    currency = clone.currency;
    description = clone.description;
    attachment = clone.attachment;
    frequency = clone.frequency;
    endAfter = clone.endAfter;
  }

  ModalTransaction copyWith(ModalTransaction source) {
    category = source.category ?? category;
    money = source.money ?? money;
    timeTransaction = source.timeTransaction ?? timeTransaction;
    typeTransaction = source.typeTransaction ?? typeTransaction;
    isRepeat = source.isRepeat ?? isRepeat;
    account = source.account ?? account;
    purpose = source.purpose ?? purpose;
    currency = source.currency ?? currency;
    description = source.description ?? description;
    attachment = source.attachment ?? attachment;
    frequency = source.frequency ?? frequency;
    endAfter = source.endAfter ?? endAfter;
    return this;
  }

  ModalTransaction override(ModalTransaction source) {
    category = source.category;
    money = source.money;
    timeTransaction = source.timeTransaction;
    typeTransaction = source.typeTransaction;
    isRepeat = source.isRepeat;
    account = source.account;
    purpose = source.purpose;
    currency = source.currency;
    description = source.description;
    attachment = source.attachment;
    frequency = source.frequency;
    endAfter = source.endAfter;
    return this;
  }

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
