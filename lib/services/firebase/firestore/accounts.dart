import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';

class AccountFirestore extends IFirestore {
  @override
  String getPath(String? uid) => 'users/user_$uid/accounts';

  @override
  Future<void> delete(IModal modal) async {
    if (modal is! ModalAccount) {
      throw ArgumentError("Required ModalAccount");
    }
    // Check foreign key transaction
    bool exist = await TransactionFirestore().checkAccountExists(modal);
    if (!exist) {
      return FirebaseFirestore.instance
          .collection(getPath(user?.uid))
          .doc(modal.id)
          .delete();
    }
  }

  @override
  Future<List<ModalAccount>?> read() async {
    try {
      QuerySnapshot<ModalAccount> snapshot = await FirebaseFirestore.instance
          .collection(getPath(user?.uid))
          .withConverter(
              fromFirestore: ModalAccount.fromFirestore,
              toFirestore: (ModalAccount modal, _) => modal.toFirestore())
          .get();
      return snapshot.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      return null;
    }
  }

  Future<bool> checkAccountTypeExists(ModalAccountType modal) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .where('account_type_ref',
            isEqualTo: AccountTypeFirestore().getRef(modal))
        .get()
        .then((value) => exist = value.size > 0, onError: (e) => print(e));
    return exist;
  }

  @override
  Future<ModalAccount?> getModalFromRef(DocumentReference<Object?> ref) async {
    try {
      DocumentSnapshot<ModalAccount> snapshot = await ref
          .withConverter(
              fromFirestore: ModalAccount.fromFirestore,
              toFirestore: (ModalAccount modal, _) => modal.toFirestore())
          .get();
      return snapshot.data();
    } on FirebaseException {
      return null;
    }
  }
}
