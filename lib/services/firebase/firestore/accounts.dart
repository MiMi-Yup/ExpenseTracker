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
          .collection(getPath(uid))
          .doc(modal.id)
          .delete();
    }
  }

  @override
  Future<List<ModalAccount>> read() async {
    QuerySnapshot<Map<String, dynamic>> collection =
        await FirebaseFirestore.instance.collection(getPath(uid)).get();
    return collection.docs
        .map((snapshot) => ModalAccount.fromFirestore(snapshot, null))
        .toList();
  }

  Future<bool> checkAccountTypeExists(ModalAccountType modal) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection(getPath(uid))
        .where('account_type_ref',
            isEqualTo: AccountTypeFirestore().getRef(modal))
        .get()
        .then((value) => exist = value.size > 0, onError: (e) => print(e));
    return exist;
  }
}
