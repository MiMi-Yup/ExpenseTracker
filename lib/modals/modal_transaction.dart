import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalTransactionLog extends IModal {
  DocumentReference? lastTransactionRef;
  DocumentReference? firstTransactionRef;

  ModalTransactionLog(
      {required super.id,
      this.firstTransactionRef,
      required this.lastTransactionRef});

  ModalTransactionLog.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    lastTransactionRef = data?['last_transaction_ref'];
    firstTransactionRef = data?['first_transaction_ref'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'first_transaction_ref': firstTransactionRef,
      'last_transaction_ref': lastTransactionRef
    };
  }

  @override
  Map<String, dynamic> updateFirestore() => toFirestore();
}

class ModalTransaction extends IModal {
  DocumentReference? accountRef;
  Set<String>? attachments;
  DocumentReference? categoryTypeRef;
  String? description;
  double? money;
  String? purpose;
  Map<String, dynamic>? repeat;
  DateTime? timeCreate;
  DocumentReference? transactionTypeRef;
  DocumentReference? transactionRef;

  ModalTransaction(
      {required super.id,
      required this.accountRef,
      required this.attachments,
      required this.description,
      required this.purpose,
      required this.money,
      required this.repeat,
      required this.timeCreate,
      required this.transactionRef,
      required this.transactionTypeRef,
      required this.categoryTypeRef});

  ModalTransaction.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    accountRef = data?['account_ref'];

    attachments = data?['attachments'] == null
        ? null
        : Set<String>.from(data?['attachments']);
    if (attachments != null && attachments!.isEmpty) attachments = null;

    categoryTypeRef = data?['category_type_ref'];
    description = data?['description'];
    money = data?['money'];
    purpose = data?['purpose'];

    if (data?['repeat'] != null) {
      repeat = <String, dynamic>{};
      (data?['repeat'] as Map<String, dynamic>).forEach((key, value) {
        key == 'end_after'
            ? repeat?.addAll({
                key: DateTime.fromMillisecondsSinceEpoch(
                    (value as Timestamp).millisecondsSinceEpoch)
              })
            : repeat?.addAll({key: value});
      });
    }

    timeCreate = DateTime.fromMillisecondsSinceEpoch(
        (data?['time_create'] as Timestamp).millisecondsSinceEpoch);
    transactionTypeRef = data?['transaction_type_ref'];
    transactionRef = data?['transaction_ref'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'account_ref': accountRef,
      'attachments': attachments?.toList(),
      'category_type_ref': categoryTypeRef,
      'description': description,
      'money': money,
      'purpose': purpose,
      'repeat': repeat,
      'time_create': timeCreate,
      'transaction_type_ref': transactionTypeRef,
      'transaction_ref': transactionRef
    };
  }

  @override
  Map<String, dynamic> updateFirestore() => {'transaction_ref': transactionRef};

  ModalTransaction.minInit({required this.transactionTypeRef}) : super(id: '');

  ModalTransaction.clone(ModalTransaction clone) : super(id: '') {
    id = clone.id;
    accountRef = clone.accountRef;
    attachments = clone.attachments;
    categoryTypeRef = clone.categoryTypeRef;
    description = clone.description;
    money = clone.money;
    purpose = clone.purpose;
    repeat = clone.repeat;
    timeCreate = clone.timeCreate;
    transactionTypeRef = clone.transactionTypeRef;
    transactionRef = clone.transactionRef;
  }

  ModalTransaction copyWith(ModalTransaction source) {
    id = source.id ?? id;
    accountRef = source.accountRef ?? accountRef;
    attachments = source.attachments ?? attachments;
    categoryTypeRef = source.categoryTypeRef ?? categoryTypeRef;
    description = source.description ?? description;
    money = source.money ?? money;
    purpose = source.purpose ?? purpose;
    repeat = source.repeat ?? repeat;
    timeCreate = source.timeCreate ?? timeCreate;
    transactionTypeRef = source.transactionTypeRef ?? transactionTypeRef;
    transactionRef = source.transactionRef ?? transactionRef;
    return this;
  }

  ModalTransaction override_(ModalTransaction source) {
    id = source.id;
    accountRef = source.accountRef;
    attachments = source.attachments;
    categoryTypeRef = source.categoryTypeRef;
    description = source.description;
    money = source.money;
    purpose = source.purpose;
    repeat = source.repeat;
    timeCreate = source.timeCreate;
    transactionTypeRef = source.transactionTypeRef;
    transactionRef = source.transactionRef;
    return this;
  }

  ModalTransaction update(ModalTransaction source) {
    id = source.id;
    accountRef = source.accountRef;
    attachments = source.attachments;
    categoryTypeRef = source.categoryTypeRef;
    description = source.description;
    money = source.money;
    purpose = source.purpose;
    repeat = source.repeat;
    timeCreate = source.timeCreate;
    transactionTypeRef = source.transactionTypeRef;
    transactionRef = source.transactionRef;
    return this;
  }

  String get getTimeTransaction {
    if (timeCreate != null) {
      int hour = timeCreate!.hour;
      int minute = timeCreate!.minute;
      bool isPM = hour >= 12;
      hour = hour > 12 ? hour - 12 : hour;

      return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute} ${isPM ? "PM" : "AM"}";
    }
    return "";
  }

  String get getFullTimeTransaction {
    if (timeCreate != null) {
      int hour = timeCreate!.hour;
      int minute = timeCreate!.minute;
      int second = timeCreate!.second;
      bool isPM = hour >= 12;
      hour = hour > 12 ? hour - 12 : hour;

      return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}:${second < 10 ? "0$second" : second} ${isPM ? "PM" : "AM"}";
    }
    return "";
  }

  String get getDateTransaction => timeCreate != null
      ? "${timeCreate!.day}/${timeCreate!.month}/${timeCreate!.year}"
      : "";

  String getMoney(String currencyCode) =>
      money != null ? "$currencyCode ${money!.toStringAsFixed(2)}" : "";
}
