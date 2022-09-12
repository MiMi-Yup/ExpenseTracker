import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';

class NotificationBudgetFirestore {
  final CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();
  final BudgetFirestore serviceBudget = BudgetFirestore();
  NotificationBudgetFirestore() {}

  void x() {
    serviceBudget.stream.listen((event) {});
  }
}
