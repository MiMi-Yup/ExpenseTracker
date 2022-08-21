import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/screens/modal/modal_transaction.dart';

class DataSample {
  static Map<DateTime, List<ModalTransaction>?> sample =
      <DateTime, List<ModalTransaction>?>{
    DateTime.now(): List<ModalTransaction>.generate(
        10,
        (index) => ModalTransaction(
            category: ECategory.bill,
            money: index * 1.683,
            timeTransaction: DateTime.now(),
            typeTransaction: index % 2 == 0
                ? ETypeTransaction.income
                : ETypeTransaction.expense,
            account: "Paypal",
            isRepeat: false,
            purpose: 'Buy electronic',
            currency: '\$')),
    DateTime.now(): List<ModalTransaction>.generate(
        10,
        (index) => ModalTransaction(
            category: ECategory.bill,
            money: index * 1.683,
            timeTransaction: DateTime.now(),
            typeTransaction: index % 2 == 0
                ? ETypeTransaction.income
                : ETypeTransaction.expense,
            account: "Paypal",
            isRepeat: false,
            purpose: 'Buy electronic',
            currency: '\$')),
    DateTime.now(): List<ModalTransaction>.generate(
        10,
        (index) => ModalTransaction(
            category: ECategory.bill,
            money: index * 1.683,
            timeTransaction: DateTime.now(),
            typeTransaction: index % 2 == 0
                ? ETypeTransaction.income
                : ETypeTransaction.expense,
            account: "Paypal",
            isRepeat: false,
            purpose: 'Buy electronic',
            currency: '\$')),
    DateTime.now(): List<ModalTransaction>.generate(
        10,
        (index) => ModalTransaction(
            category: ECategory.bill,
            money: index * 1.683,
            timeTransaction: DateTime.now(),
            typeTransaction: index % 2 == 0
                ? ETypeTransaction.income
                : ETypeTransaction.expense,
            account: "Paypal",
            isRepeat: false,
            purpose: 'Buy electronic',
            currency: '\$')),
    DateTime.now(): List<ModalTransaction>.generate(
        10,
        (index) => ModalTransaction(
            category: ECategory.bill,
            money: index * 1.683,
            timeTransaction: DateTime.now(),
            typeTransaction: index % 2 == 0
                ? ETypeTransaction.income
                : ETypeTransaction.expense,
            account: "Paypal",
            isRepeat: false,
            purpose: 'Buy electronic',
            currency: '\$')),
    DateTime.now(): List<ModalTransaction>.generate(
        10,
        (index) => ModalTransaction(
            category: ECategory.bill,
            money: index * 1.683,
            timeTransaction: DateTime.now(),
            typeTransaction: index % 2 == 0
                ? ETypeTransaction.income
                : ETypeTransaction.expense,
            account: "Paypal",
            isRepeat: false,
            purpose: 'Buy electronic',
            currency: '\$'))
  };

  static List<ModalTransaction>? _allItem;

  static List<ModalTransaction> convertToList() {
    if (_allItem == null) {
      _allItem ??= List<ModalTransaction>.empty(growable: true);
      sample.forEach((key, value) {
        _allItem!.addAll(value!);
      });
    }
    return _allItem!;
  }

  
}
