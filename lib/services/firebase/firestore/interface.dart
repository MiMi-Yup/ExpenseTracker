import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IFirestore {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> insert(IModal modal) {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .set(modal.toFirestore(), SetOptions(merge: true));
  }

  Future<void> update(IModal was, IModal update) {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(was.id)
        .update(update.updateFirestore());
  }

  DocumentReference<Map<String, dynamic>> getRef(IModal modal) {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(modal.id);
  }

  CollectionReference<Map<String, dynamic>> getFirebaseRef() =>
      FirebaseFirestore.instance.collection(getPath(user?.uid));

  Future<void> delete(IModal modal);
  String getPath(String? uid);
  Future<List<IModal>?> read();
  Future<IModal?> getModalFromRef(DocumentReference<Object?> ref);
}
