import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';

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
        .doc(getPath(uid))
        .set(modal.toFirestore());
  }

  @override
  Future<void> update(IModal? was, IModal update) {
    return FirebaseFirestore.instance
        .doc(getPath(uid))
        .update(update.updateFirestore());
  }

  @override
  DocumentReference<Map<String, dynamic>> getRef(IModal modal) {
    return FirebaseFirestore.instance.doc(getPath(uid));
  }

  @override
  Future<List<ModalUser>> read() async {
    DocumentSnapshot<ModalUser> snapshot = await FirebaseFirestore.instance
        .doc(getPath(uid))
        .withConverter(
            fromFirestore: ModalUser.fromFirestore,
            toFirestore: (ModalUser user, _) => user.toFirestore())
        .get();
    ModalUser? modal = snapshot.data();
    if (modal != null) {
      modal.id = snapshot.id;
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

  Future<ModalCurrencyType?> getMainCurrencyAccount() async {
    List<ModalUser> modals = await read();
    if (modals.isNotEmpty) {
      DocumentSnapshot<ModalCurrencyType> snapshot = await modals
          .first.currencyTypeRef!
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
        .doc(getPath(uid))
        .get()
        .then<bool>((value) => value.exists);
  }
}
