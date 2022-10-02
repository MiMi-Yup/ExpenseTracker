import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/instances/currency_type_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/screens/tab/nav.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';

enum SortBy { money, time }

enum SortOrder { descending, ascending }

class FilterTransaction {
  final CurrentTransactionFirestore _serviceLog = CurrentTransactionFirestore();

  String _getDate(DateTime date) =>
      "${date.year}-${date.month >= 10 ? date.month : "0${date.month}"}-${date.day >= 10 ? date.day : "0${date.day}"}";

  Future<Map<ModalTransaction, ModalTransaction?>> _mappingCompareTimeCreate(
      Map<String, List<ModalTransaction>?> data) async {
    Map<ModalTransaction, ModalTransaction?> map = {};

    for (List<ModalTransaction>? modal in data.values) {
      if (modal != null) {
        for (ModalTransaction element in modal) {
          map.addAll({element: null});
        }
      }
    }

    for (ModalTransaction modal in map.keys) {
      map[modal] = await _serviceLog.findFirstTransaction(modal);
    }

    return map;
  }

  bool _acceptPushTransaction(
      {required ModalTransaction modal,
      ModalCategoryType? selectedFilterCategory,
      ModalTransactionType? selectedFilterTransactionType}) {
    if ((selectedFilterCategory == null
            ? true
            : selectedFilterCategory.id == modal.categoryTypeRef?.id) &&
        (selectedFilterTransactionType == null
            ? true
            : selectedFilterTransactionType.id ==
                modal.transactionTypeRef?.id)) {
      return true;
    }

    return false;
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>> _sortByTime(
      {required Map<String, List<ModalTransaction>?> result,
      required SortOrder sortOrder}) async {
    //get first modal (not modified yet)
    Map<ModalTransaction, ModalTransaction?> mapCompare =
        await _mappingCompareTimeCreate(result);

    //sort each group by timeCreate
    for (String element in result.keys) {
      result[element]!.sort((modal1, modal2) {
        ModalTransaction? compare1 = sortOrder == SortOrder.ascending
            ? mapCompare[modal1]
            : mapCompare[modal2];
        ModalTransaction? compare2 = sortOrder == SortOrder.ascending
            ? mapCompare[modal2]
            : mapCompare[modal1];
        return compare1!.timeCreate!.compareTo(compare2!.timeCreate!);
      });
    }

    //sort key of group
    return SplayTreeMap<String, List<ModalTransaction>?>.from(
        result,
        (key1, key2) =>
            DateTime.parse(sortOrder == SortOrder.ascending ? key1 : key2)
                .compareTo(DateTime.parse(
                    sortOrder == SortOrder.ascending ? key2 : key1)));
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>> _sortByMoney(
      {required Map<String, List<ModalTransaction>?> result,
      required SortOrder sortOrder}) async {
    for (String element in result.keys) {
      result[element]!.sort((modal1, modal2) =>
          ((sortOrder == SortOrder.ascending ? modal1 : modal2).money! -
                  (sortOrder == SortOrder.ascending ? modal2 : modal1).money!)
              .toInt());
    }

    return SplayTreeMap<String, List<ModalTransaction>?>.from(
        result,
        (key1, key2) =>
            DateTime.parse(sortOrder == SortOrder.ascending ? key1 : key2)
                .compareTo(DateTime.parse(
                    sortOrder == SortOrder.ascending ? key2 : key1)));
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>> filterTransaction(
      {required QuerySnapshot<ModalTransactionLog> querySnapshot,
      SortBy? sortBy,
      ModalCategoryType? selectedFilterCategory,
      ModalTransactionType? selectedFilterTransactionType,
      required SortOrder sortOrder}) async {
    TransactionFirestore serviceTransaction = TransactionFirestore();

    Map<String, List<ModalTransaction>?> result =
        <String, List<ModalTransaction>?>{};

    Iterable<ModalTransactionLog?> iterable =
        querySnapshot.docs.map<ModalTransactionLog?>((e) => e.data());

    //fliter day to group
    for (ModalTransactionLog? element in iterable) {
      ModalTransaction? currerntModal = element!.lastTransactionRef == null
          ? null
          : await serviceTransaction
              .getModalFromRef(element.lastTransactionRef!);
      ModalTransaction? firstModal = await serviceTransaction
          .getModalFromRef(element.firstTransactionRef!);
      ModalTransaction? push = currerntModal ?? firstModal;

      if (push != null &&
          firstModal?.getTimeCreate?.year == Navigation.filterByDate.year &&
          firstModal?.getTimeCreate?.month == Navigation.filterByDate.month &&
          _acceptPushTransaction(
              modal: push,
              selectedFilterCategory: selectedFilterCategory,
              selectedFilterTransactionType: selectedFilterTransactionType)) {
        String key = _getDate(firstModal!.getTimeCreate!);
        if (result.containsKey(key)) {
          result[key]!.add(push);
        } else {
          result.addAll({
            key: [push]
          });
        }
      }
    }

    switch (sortBy) {
      case SortBy.time:
        return _sortByTime(result: result, sortOrder: sortOrder);
      case SortBy.money:
        return _sortByMoney(result: result, sortOrder: sortOrder);
      default:
        return _sortByTime(result: result, sortOrder: sortOrder);
    }
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>>
      filterTransactionAccount(
          {required Map<String, List<ModalTransaction>?> map,
          SortOrder sortOrder = SortOrder.descending}) async {
    return _sortByTime(result: map, sortOrder: sortOrder);
  }
}

class MultiCurrency {
  static Future<double> convertTransactionByCurrency(
      {required ModalCurrencyType targetCurrency,
      required List<ModalTransaction> modals}) async {
    final AccountFirestore service = AccountFirestore();

    ModalTransactionType? transactionType;
    ModalCurrencyType? currencyType;
    ModalAccount? account;

    double result = 0.0;

    for (ModalTransaction modal in modals) {
      transactionType = TranasactionTypeInstance.instance()
          .getModal(modal.transactionTypeRef!.id);
      account = await service.getModalFromRef(modal.accountRef!);
      if (account != null) {
        currencyType = CurrencyTypeInstance.instance()
            .getModal(account.currencyTypeRef!.id);
        switch (transactionType?.operator) {
          case '-':
            result -= modal.money! /
                currencyType!.coefficient! *
                targetCurrency.coefficient!;
            break;
          case '+':
            result += modal.money! /
                currencyType!.coefficient! *
                targetCurrency.coefficient!;
            break;
        }
      } else {
        continue;
      }
    }

    return result;
  }

  static double convertBalanceToCurrency(
      {required ModalCurrencyType targetCurrency,
      required List<ModalAccount> modals}) {
    ModalCurrencyType? currencyType;

    double result = 0.0;

    for (ModalAccount modal in modals) {
      currencyType =
          CurrencyTypeInstance.instance().getModal(modal.currencyTypeRef!.id);
      result += modal.money! /
          currencyType!.coefficient! *
          targetCurrency.coefficient!;
    }

    return result;
  }
}
