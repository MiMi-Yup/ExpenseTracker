import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalAccount extends IModal {
  DocumentReference? accountTypeRef;
  double? money;

  ModalAccount(
      {required super.id, required this.accountTypeRef, required this.money});

  ModalAccount.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    accountTypeRef = data?['account_type_ref'];
    money = data?['money'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {'account_type_ref': accountTypeRef, 'money': money};
  }

  @override
  Map<String, dynamic> updateFirestore() => toFirestore();

  @override
  String toString() =>
      "${accountTypeRef?.id[0].toUpperCase()}${accountTypeRef?.id.substring(1).toLowerCase()}";

  @override
  bool operator ==(dynamic other) =>
      other != null && other is ModalAccount && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
