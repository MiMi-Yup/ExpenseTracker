import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalCurrencyType extends IModal {
  double? coefficient;
  String? currencyCode;
  String? currencyName;

  ModalCurrencyType(
      {required super.id,
      required this.coefficient,
      required this.currencyCode,
      required this.currencyName});

  ModalCurrencyType.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    coefficient = data?['coefficient'];
    currencyCode = data?['currency_code'];
    currencyName = data?['currency_name'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'coefficient': coefficient,
      'currency_code': currencyCode,
      'currency_name': currencyName
    };
  }

  @override
  Map<String, dynamic> updateFirestore() => toFirestore();

  @override
  String toString() => '$currencyName ($currencyCode)';

  @override
  bool operator ==(dynamic other) =>
      other != null && other is ModalCurrencyType && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
