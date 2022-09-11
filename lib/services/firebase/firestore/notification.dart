import 'package:expense_tracker/modals/modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_notification.dart';
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
    DocumentSnapshot<ModalNotification> snapshot = await ref
        .withConverter(
            fromFirestore: ModalNotification.fromFirestore,
            toFirestore: (ModalNotification modal, _) => modal.toFirestore())
        .get();
    return snapshot.data();
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
  Future<List<ModalNotification>> read() async {
    QuerySnapshot<ModalNotification> snapshot = await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalNotification.fromFirestore,
            toFirestore: (ModalNotification modal, _) => modal.toFirestore())
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<QuerySnapshot<ModalNotification>> get stream =>
      FirebaseFirestore.instance
          .collection(getPath(user?.uid))
          .withConverter(
              fromFirestore: ModalNotification.fromFirestore,
              toFirestore: (ModalNotification modal, _) => modal.toFirestore())
          .snapshots(includeMetadataChanges: true);

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
}
