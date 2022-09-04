import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestore extends IFirestore {
  @override
  Future<void> delete(IModal modal) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  String getPath(String? uid) => 'users/user_$uid';

  @override
  Future<void> insert(IModal modal) {
    return FirebaseFirestore.instance
        .doc(getPath(user?.uid))
        .set(modal.toFirestore());
  }

  @override
  Future<void> update(IModal? was, IModal update) {
    return FirebaseFirestore.instance
        .doc(getPath(user?.uid))
        .update(update.updateFirestore());
  }

  @override
  DocumentReference<Map<String, dynamic>> getRef(IModal modal) {
    return FirebaseFirestore.instance.doc(getPath(user?.uid));
  }

  @override
  Future<List<ModalUser>> read() async {
    DocumentSnapshot<ModalUser> snapshot = await FirebaseFirestore.instance
        .doc(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalUser.fromFirestore,
            toFirestore: (ModalUser user, _) => user.toFirestore())
        .get();
    ModalUser? modal = snapshot.data();
    if (modal != null) {
      modal.displayName = user?.displayName;
      modal.email = user?.email;
      modal.emailVerified = user?.emailVerified;
      modal.phoneNumber = user?.phoneNumber;
      modal.photoURL = user?.photoURL;
      return [modal];
    }
    return [];
  }

  @override
  Future<ModalUser?> getModalFromRef(
      DocumentReference<Map<String, dynamic>> ref) async {
    DocumentSnapshot<ModalUser> snapshot = await ref
        .withConverter(
            fromFirestore: ModalUser.fromFirestore,
            toFirestore: (ModalUser modal, _) => modal.toFirestore())
        .get();
    return snapshot.data();
  }

  Future<ModalCurrencyType?> getMainCurrencyAccount({ModalUser? modal}) async {
    if (modal == null) {
      List<ModalUser> modals = await read();
      if (modals.isNotEmpty) {
        modal = modals.first;
      }
    }

    if (modal != null) {
      DocumentSnapshot<ModalCurrencyType> snapshot = await modal
          .currencyTypeRef!
          .withConverter(
              fromFirestore: ModalCurrencyType.fromFirestore,
              toFirestore: (ModalCurrencyType modal, _) => modal.toFirestore())
          .get();
      return snapshot.data();
    }
    return null;
  }

  Future<bool> checkUserExists() {
    return FirebaseFirestore.instance
        .doc(getPath(user?.uid))
        .get()
        .then<bool>((value) => value.exists);
  }
}
