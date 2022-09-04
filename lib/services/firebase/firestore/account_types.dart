import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';

class AccountTypeFirestore extends IFirestore {
  @override
  String getPath(String? uid) => "users/user_$uid/account_types";

  @override
  Future<void> delete(IModal modal) async {
    //Check argument
    if (modal is! ModalAccountType) {
      throw ArgumentError("Required ModalAccountType");
    }
    //Check foreign key accounts
    bool exist = await AccountFirestore().checkAccountTypeExists(modal);

    if (!exist) {
      return FirebaseFirestore.instance
          .collection(getPath(user?.uid))
          .doc(modal.id)
          .delete();
    }
  }

  @override
  Future<List<ModalAccountType>> read() async {
    QuerySnapshot<ModalAccountType> snapshot = await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalAccountType.fromFirestore,
            toFirestore: (ModalAccountType accountType, _) =>
                accountType.toFirestore())
        .get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<ModalAccountType?> getModalFromRef(
      DocumentReference<Object?> ref) async {
    DocumentSnapshot<ModalAccountType> snapshot = await ref
        .withConverter(
            fromFirestore: ModalAccountType.fromFirestore,
            toFirestore: (ModalAccountType modal, _) => modal.toFirestore())
        .get();
    return snapshot.data();
  }
}
