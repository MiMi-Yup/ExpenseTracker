import 'package:expense_tracker/modals/modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_notification.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';

class NotificationFirestore extends IFirestore {
  @override
  Future<void> delete(IModal modal) {
    if (modal is! ModalNotification) {
      throw ArgumentError('Request ModalNotification');
    }

    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .delete();
  }

  @override
  Future<ModalNotification?> getModalFromRef(
      DocumentReference<Object?> ref) async {
    try {
      DocumentSnapshot<ModalNotification> snapshot = await ref
          .withConverter(
              fromFirestore: ModalNotification.fromFirestore,
              toFirestore: (ModalNotification modal, _) => modal.toFirestore())
          .get();
      return snapshot.data();
    } on FirebaseException {
      return null;
    }
  }

  @override
  Future<void> insert(IModal modal) {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .add(modal.toFirestore())
        .then((value) => modal.id = value.id);
  }

  @override
  String getPath(String? uid) => 'users/user_$uid/notifications';

  @override
  Future<List<ModalNotification>?> read() async {
    try {
      QuerySnapshot<ModalNotification> snapshot = await FirebaseFirestore
          .instance
          .collection(getPath(user?.uid))
          .withConverter(
              fromFirestore: ModalNotification.fromFirestore,
              toFirestore: (ModalNotification modal, _) => modal.toFirestore())
          .get();

      return snapshot.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      return null;
    }
  }

  Stream<QuerySnapshot<ModalNotification>> get stream =>
      FirebaseFirestore.instance
          .collection(getPath(user?.uid))
          .withConverter(
              fromFirestore: ModalNotification.fromFirestore,
              toFirestore: (ModalNotification modal, _) => modal.toFirestore())
          .snapshots(includeMetadataChanges: true);

  Future<void> setRead(ModalNotification modal) {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .update({'is_read': true});
  }

  Future<void> setReadAll() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot<ModalNotification> snapshot = await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalNotification.fromFirestore,
            toFirestore: (ModalNotification modal, _) => modal.toFirestore())
        .get();

    snapshot.docs.map((e) => getRef(e.data())).forEach((element) {
      batch.update(element, {'is_read': true});
    });

    return batch.commit();
  }

  Future<void> deleteAll() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot<ModalNotification> snapshot = await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalNotification.fromFirestore,
            toFirestore: (ModalNotification modal, _) => modal.toFirestore())
        .get();

    snapshot.docs.map((e) => getRef(e.data())).forEach((element) {
      batch.delete(element);
    });

    return batch.commit();
  }

  Future<List<ModalNotification>?> checkBudgetExists(ModalBudget modal) async {
    try {
      QuerySnapshot<ModalNotification> snapshot = await FirebaseFirestore
          .instance
          .collection(getPath(user?.uid))
          .where('budget_ref', isEqualTo: BudgetFirestore().getRef(modal))
          .withConverter(
              fromFirestore: ModalNotification.fromFirestore,
              toFirestore: (ModalNotification modal, _) => modal.toFirestore())
          .get();

      return snapshot.size == 0
          ? null
          : snapshot.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      return null;
    }
  }
}
