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
          .collection(getPath(uid))
          .doc(modal.id)
          .delete();
    }
  }

  @override
  Future<List<ModalTransactionType>> read() async {
    QuerySnapshot<ModalTransactionType> snapshot = await FirebaseFirestore
        .instance
        .collection(getPath(uid))
        .withConverter(
            fromFirestore: ModalTransactionType.fromFirestore,
            toFirestore: (ModalTransactionType transactionType, _) =>
                transactionType.toFirestore())
        .get();
    return snapshot.docs.map((e) => e.data()).toList();
  }
}
