import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';

class CategoryTypeFirebase extends IFirestore {
  @override
  String getPath(String? uid) => 'users/user_$uid/category_types';

  @override
  Future<void> delete(IModal modal) async {
    if (modal is! ModalCategoryType) {
      throw ArgumentError("Required ModalCategoryType");
    }
    //Check foreign key budget
    bool budgetExist = await BudgetFirestore().checkCategoryTypeExists(modal);
    //Check foreign key transaction
    bool transactionExist =
        await TransactionFirestore().checkCategoryTypeExists(modal);

    if (!(budgetExist || transactionExist)) {
      return FirebaseFirestore.instance
          .collection(getPath(uid))
          .doc(modal.id)
          .delete();
    }
  }

  @override
  Future<List<ModalCategoryType>> read() async {
    QuerySnapshot<Map<String, dynamic>> collection =
        await FirebaseFirestore.instance.collection(getPath(uid)).get();
    return collection.docs
        .map((snapshot) => ModalCategoryType.fromFirestore(snapshot, null))
        .toList();
  }
}
