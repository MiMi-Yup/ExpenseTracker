import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_notification.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/notification.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';

class BudgetUtilities {
  final BudgetFirestore _service = BudgetFirestore();
  Future<dynamic> add(ModalBudget modal) async {
    List<ModalBudget>? modals = await _service.read();
    if (modals != null && modals.isNotEmpty) {
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
    }

    return _service.insert(modal);
  }

  Future<void> delete(ModalBudget modal) async {
    NotificationFirestore serviceNotification = NotificationFirestore();

    List<ModalNotification>? listNotificationRef =
        await serviceNotification.checkBudgetExists(modal);

    if (listNotificationRef?.isNotEmpty == true) {
      listNotificationRef?.forEach((element) {
        serviceNotification.delete(element);
      });
    }

    _service.delete(modal);
  }

  Future<List<ModalTransaction>> getTransactionsInBudget(
      ModalBudget modal) async {
    CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();
    TransactionFirestore serviceTransaction = TransactionFirestore();
    TransactionTypeFirestore serviceTransactionType =
        TransactionTypeFirestore();

    DocumentReference? categoryRef = modal.categoryTypeRef;
    DateTime timeCreate = modal.getTimeCreate!;
    DateTime startDate = DateTime(timeCreate.year, timeCreate.month, 1);
    DateTime endDate = DateTime(timeCreate.year, timeCreate.month + 1, 0);

    List<ModalTransactionLog>? logs = await serviceLog.read();
    Iterable<DocumentReference<Object?>>? transactionRefs =
        logs?.map((e) => e.lastTransactionRef ?? e.firstTransactionRef!);

    List<ModalTransaction> results = [];

    if (transactionRefs != null) {
      for (DocumentReference<Object?> transactionRef in transactionRefs) {
        ModalTransaction? transactionModal =
            await serviceTransaction.getModalFromRef(transactionRef);

        ModalTransactionType? transactionType;

        if (transactionModal != null &&
            transactionModal.transactionTypeRef != null) {
          transactionType = await serviceTransactionType
              .getModalFromRef(transactionModal.transactionTypeRef!);
        } else {
          continue;
        }
        if (transactionModal.categoryTypeRef?.id == categoryRef?.id &&
            transactionType?.operator == '-' &&
            transactionModal.timeCreate!
                    .compareTo(Timestamp.fromDate(startDate)) >=
                0 &&
            transactionModal.timeCreate!
                    .compareTo(Timestamp.fromDate(endDate)) <=
                0) {
          results.add(transactionModal);
        }
      }
    }

    return results;
  }
}
