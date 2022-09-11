import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:firebase_core/firebase_core.dart';

class BudgetUtilities {
  final BudgetFirestore service = BudgetFirestore();
  Future<dynamic> add(ModalBudget modal) async {
    List<ModalBudget> modals = await service.read();
    ModalBudget existModal = modals.singleWhere((element) {
      DateTime? existsBudget = element.timeCreate?.toDate();
      DateTime? addBudget = modal.timeCreate?.toDate();
      if (element.categoryTypeRef?.id != modal.categoryTypeRef?.id ||
          existsBudget?.year != addBudget?.year ||
          existsBudget?.month != addBudget?.month) return false;
      return true;
    },
        orElse: () => ModalBudget(
            id: null,
            budget: null,
            percentAlert: null,
            timeCreate: null,
            categoryTypeRef: null));

    if (existModal.id != null) return existModal;
    return service.insert(modal);
  }

  Future<void> delete(ModalBudget modal) async {
    return service.delete(modal);
  }
}
