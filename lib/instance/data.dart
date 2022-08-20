import 'package:expense_tracker/constant/enum/enum_category.dart';
import 'package:expense_tracker/constant/enum/enum_transaction.dart';
import 'package:expense_tracker/page/add_edit_transaction/modal_transaction.dart';

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

  static List<ModalTransaction> convertToList() {
    List<ModalTransaction> list = List<ModalTransaction>.empty(growable: true);
    sample.forEach((key, value) {
      list.addAll(value!);
    });
    return list;
  }
}
