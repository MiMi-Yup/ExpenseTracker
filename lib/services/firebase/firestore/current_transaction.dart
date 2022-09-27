import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';

class CurrentTransactionFirestore extends IFirestore {
  @override
  Future<void> delete(IModal modal) async {
    if (modal is! ModalTransaction) {
      throw ArgumentError('Request ModalTransaction');
    }

    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .delete();
  }

  @override
  Future<IModal?> getModalFromRef(DocumentReference<Object?> ref) async {
    return null;
  }

  @override
  String getPath(String? uid) => 'users/user_$uid/current_transactions';

  @override
  Future<List<ModalTransactionLog>?> read() async {
    try {
      QuerySnapshot<ModalTransactionLog> snapshot = await FirebaseFirestore
          .instance
          .collection(getPath(user?.uid))
          .withConverter(
              fromFirestore: ModalTransactionLog.fromFirestore,
              toFirestore: (ModalTransactionLog modal, _) =>
                  modal.toFirestore())
          .get();

      return snapshot.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      return null;
    }
  }

  Stream<QuerySnapshot<ModalTransactionLog>> get stream => FirebaseFirestore
      .instance
      .collection(getPath(user?.uid))
      .withConverter(
          fromFirestore: ModalTransactionLog.fromFirestore,
          toFirestore: (ModalTransactionLog modal, _) => modal.toFirestore())
      .snapshots(includeMetadataChanges: true);

  Future<ModalTransaction?> findFirstTransaction(ModalTransaction modal) async {
    ModalTransactionLog? log = await findTransactionLog(modal);

    return log != null
        ? await TransactionFirestore().getModalFromRef(log.firstTransactionRef!)
        : modal;
  }

  Future<ModalTransactionLog?> findTransactionLog(
      ModalTransaction modal) async {
    TransactionFirestore service = TransactionFirestore();

    try {
      //modal is first transaction ref = id document
      DocumentSnapshot<ModalTransactionLog> snapshot = await FirebaseFirestore
          .instance
          .collection(getPath(user?.uid))
          .doc(modal.id)
          .withConverter(
              fromFirestore: ModalTransactionLog.fromFirestore,
              toFirestore: (ModalTransactionLog modal, _) =>
                  modal.toFirestore())
          .get();
      if (snapshot.exists) {
        return snapshot.data();
      } else if (modal.transactionRef == null) {
        //modal isn't first transaction ref and no ref to other modal => no exist in log
        return null;
      }

      //modal is current transaction (last transaction ref)
      QuerySnapshot<ModalTransactionLog> query = await FirebaseFirestore
          .instance
          .collection(getPath(user?.uid))
          .where('last_transaction_ref', isEqualTo: service.getRef(modal))
          .withConverter(
              fromFirestore: ModalTransactionLog.fromFirestore,
              toFirestore: (ModalTransactionLog modal, _) =>
                  modal.toFirestore())
          .get();
      if (query.size == 1) return query.docs.first.data();

      //modal in middle linked list log
      ModalTransaction? iterableModal = modal;
      while (iterableModal != null && iterableModal.transactionRef != null) {
        iterableModal =
            await service.getModalFromRef(iterableModal.transactionRef!);
      }
      if (iterableModal != null) {
        return await findTransactionLog(iterableModal);
      }
    } on FirebaseException {
      return null;
    }

    throw FirebaseException(plugin: 'Structure firestore error');
  }
}
