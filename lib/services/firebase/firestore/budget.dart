import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';

class BudgetFirestore extends IFirestore {
  @override
  Future<void> delete(IModal modal) {
    if (modal is! ModalBudget) {
      throw ArgumentError("Required ModalAccount");
    }

    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .delete();
  }

  @override
  Future<List<ModalBudget>> read() async {
    QuerySnapshot<Map<String, dynamic>> collection =
        await FirebaseFirestore.instance.collection(getPath(user?.uid)).get();
    return collection.docs
        .map((snapshot) => ModalBudget.fromFirestore(snapshot, null))
        .toList();
  }

  Future<bool> checkCategoryTypeExists(ModalCategoryType modal) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .where('category_type_ref',
            isEqualTo: CategoryTypeFirebase().getRef(modal))
        .get()
        .then((value) => exist = value.size > 0, onError: (e) => print(e));
    return exist;
  }

  @override
  String getPath(String? uid) => 'users/user_$uid/budgets';

  @override
  Future<ModalBudget?> getModalFromRef(DocumentReference<Object?> ref) async {
    DocumentSnapshot<ModalBudget> snapshot = await ref
        .withConverter(
            fromFirestore: ModalBudget.fromFirestore,
            toFirestore: (ModalBudget modal, _) => modal.toFirestore())
        .get();
    return snapshot.data();
  }

  Stream<QuerySnapshot<ModalBudget>> get stream => FirebaseFirestore.instance
      .collection(getPath(user?.uid))
      .withConverter(
          fromFirestore: ModalBudget.fromFirestore,
          toFirestore: (ModalBudget modal, _) => modal.toFirestore())
      .snapshots(includeMetadataChanges: true);
}
