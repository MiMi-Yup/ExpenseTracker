import 'package:expense_tracker/modals/modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';

class CurrentTransaction extends IFirestore {
  @override
  Future<void> delete(IModal modal) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<IModal?> getModalFromRef(
      DocumentReference<Map<String, dynamic>> ref) async {
    return null;
  }

  @override
  String getPath(String? uid) => 'users/user_$uid/current_transactions';

  @override
  Future<List<ModalTransactionLog>> read() async {
    QuerySnapshot<ModalTransactionLog> snapshot = await FirebaseFirestore
        .instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalTransactionLog.fromFirestore,
            toFirestore: (ModalTransactionLog modal, _) => modal.toFirestore())
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<List<ModalTransaction>> getTargetTransaction() async {
    List<ModalTransactionLog> modals = await read();
    List<ModalTransaction> results = [];

    for (var element in modals) {
      DocumentSnapshot<ModalTransaction> snapshot =
          await (element.lastTransactionRef ?? element.firstTransactionRef)!
              .withConverter(
                  fromFirestore: ModalTransaction.fromFirestore,
                  toFirestore: (ModalTransaction modal, _) =>
                      modal.toFirestore())
              .get();
      if (snapshot.exists) {
        results.add(snapshot.data()!);
      }
    }

    return results;
  }

  Stream<QuerySnapshot<ModalTransactionLog>> getStreamTransaction() {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalTransactionLog.fromFirestore,
            toFirestore: (ModalTransactionLog modal, _) => modal.toFirestore())
        .snapshots(includeMetadataChanges: true);
  }

  Future<ModalTransactionLog?> findTransactionLog(
      ModalTransaction modal) async {
    if (modal.transactionRef == null) return null;

    DocumentSnapshot<ModalTransactionLog> snapshot = await FirebaseFirestore
        .instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .withConverter(
            fromFirestore: ModalTransactionLog.fromFirestore,
            toFirestore: (ModalTransactionLog modal, _) => modal.toFirestore())
        .get();
    if (snapshot.exists) return snapshot.data();

    QuerySnapshot<ModalTransactionLog> query = await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .where('last_transaction_ref', isEqualTo: modal.transactionRef)
        .withConverter(
            fromFirestore: ModalTransactionLog.fromFirestore,
            toFirestore: (ModalTransactionLog modal, _) => modal.toFirestore())
        .get();
    if (query.size == 1) return query.docs.first.data();

    throw FirebaseException(plugin: 'Structure firestore error');
  }
}
