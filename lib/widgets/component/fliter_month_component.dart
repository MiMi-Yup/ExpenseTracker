import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:expense_tracker/widgets/month_picker.dart';
import 'package:flutter/material.dart';

abstract class FliterMonthComponent {
  Key? key;
  DateTime? maxFliterTransactionByMonth;
  DateTime? minFilterTransactionByMonth;
  DateTime? selectedDate;
  Future<Map<String, IModal?>?> get _loadFilter;

  void Function(DateTime)? onChanged;
  void Function(DateTime)? setInitDateTime;

  FliterMonthComponent(
      {this.key,
      required this.onChanged,
      required this.setInitDateTime,
      required this.selectedDate});

  Widget builder() => FutureBuilder<Map<String, dynamic>?>(
      future: _loadFilter,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          minFilterTransactionByMonth =
              snapshot.data?['first_transaction']?.timeCreate?.toDate() ??
                  DateTime.now();
          maxFliterTransactionByMonth =
              snapshot.data?['last_transaction']?.timeCreate?.toDate() ??
                  DateTime.now();
          if (setInitDateTime != null) {
            setInitDateTime!(maxFliterTransactionByMonth!);
            selectedDate = maxFliterTransactionByMonth;
          }
          return GestureDetector(
            onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => MonthPickerStateful(
                        onChanged: onChanged,
                        startDate: minFilterTransactionByMonth!,
                        selectedDate: selectedDate,
                        lastDate: maxFliterTransactionByMonth!
                            .add(Duration(days: 365)))
                    .builder()),
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${selectedDate?.month}/${selectedDate?.year}',
                    style: TextStyle(color: Colors.white60),
                  ),
                  SizedBox(width: 10.0),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          );
        }
        return SizedBox(width: 50, child: LinearProgressIndicator());
      });
}

class FilterTransactionByMonthComponent extends FliterMonthComponent {
  final TransactionFirestore _service = TransactionFirestore();

  FilterTransactionByMonthComponent(
      {required super.onChanged,
      required super.setInitDateTime,
      required super.selectedDate});

  @override
  Future<Map<String, IModal?>?> get _loadFilter async {
    ModalTransaction? first = await _service.firstTransaction;
    ModalTransaction? last = await _service.lastTransaction;

    return {'first_transaction': first, 'last_transaction': last};
  }
}

class FilterBudgetByMonthComponent extends FliterMonthComponent {
  final BudgetFirestore _service = BudgetFirestore();

  FilterBudgetByMonthComponent(
      {required super.onChanged,
      required super.setInitDateTime,
      required super.selectedDate});

  @override
  Future<Map<String, IModal?>?> get _loadFilter async {
    ModalBudget? first = await _service.firstBudget;
    ModalBudget? last = await _service.lastBudget;

    return {'first_transaction': first, 'last_transaction': last};
  }
}
