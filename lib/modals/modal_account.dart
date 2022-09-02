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
}
