import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';

class TransactionTypeFirestore extends IFirestore {
  @override
  String getPath(String? uid) => "users/user_$uid/transaction_types";

  @override
  Future<void> delete(IModal modal) async {
    if (modal is! ModalTransactionType) {
      throw ArgumentError("Required ModalTransactionType");
    }
    //Check foreign key transaction
    // Check foreign key transaction
    bool exist = await TransactionFirestore().checkTransactionTypeExists(modal);
    if (!exist) {
      return FirebaseFirestore.instance
          .collection(getPath(user?.uid))
          .doc(modal.id)
          .delete();
    }
  }

  @override
  Future<List<ModalTransactionType>?> read() async {
    try {
      QuerySnapshot<ModalTransactionType> snapshot = await FirebaseFirestore
          .instance
          .collection(getPath(user?.uid))
          .withConverter(
              fromFirestore: ModalTransactionType.fromFirestore,
              toFirestore: (ModalTransactionType transactionType, _) =>
                  transactionType.toFirestore())
          .get();
      return snapshot.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      return null;
    }
  }

  @override
  Future<ModalTransactionType?> getModalFromRef(
      DocumentReference<Object?> ref) async {
    try {
      DocumentSnapshot<ModalTransactionType> snapshot = await ref
          .withConverter(
              fromFirestore: ModalTransactionType.fromFirestore,
              toFirestore: (ModalTransactionType modal, _) =>
                  modal.toFirestore())
          .get();
      return snapshot.data();
    } on FirebaseException {
      return null;
    }
  }
}
