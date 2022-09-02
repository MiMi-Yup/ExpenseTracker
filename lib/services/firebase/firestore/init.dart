import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_frequency_type.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:flutter/material.dart';

class InitializationFirestore {
  Future<void> init() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    _createDefaultTransactionTypesCollection(batch);
    _createCurrencyTypesCollection(batch);
    _createDefaultAccountTypesCollection(batch);
    _createDefaultTransactionTypesCollection(batch);
    _createFrequencyTypesCollection(batch);
    _createDefaultCategoryTypesCollection(batch);
    return batch.commit();
  }

  void copyDefaultToUser(String uid) {
    String pathUser = 'users/user_$uid';
    FirebaseFirestore instance = FirebaseFirestore.instance;
    Map<String, CollectionReference<Map<String, dynamic>>> map = {
      'catetory_types': instance.collection('default_category_types'),
      'account_types': instance.collection('default_account_types'),
      'transaction_types': instance.collection('default_transaction_types')
    };

    map.forEach((key, value) async {
      QuerySnapshot<Map<String, dynamic>> collection = await value.get();
      for (var element in collection.docs) {
        instance
            .doc(pathUser)
            .collection(key)
            .doc(element.id)
            .set(element.data());
      }
    });

    instance
        .doc(pathUser)
        .set(ModalUser(id: null, email: null, password: null).toFirestore());
  }

  void _createDefaultTransactionTypesCollection(WriteBatch batch) {
    const path = 'default_transaction_types';

    final Map<String, IModal> preData = <String, IModal>{
      "income": ModalTransactionType(
          id: 'income',
          color: Colors.green,
          operator: '+',
          name: 'Income',
          image: 'asset/image/icon/income.png',
          localAsset: true),
      "expense": ModalTransactionType(
          id: 'expense',
          color: Colors.red,
          operator: '-',
          name: 'Expense',
          image: 'asset/image/icon/expense.png',
          localAsset: true)
    };

    preData.forEach((key, value) {
      batch.set(FirebaseFirestore.instance.collection(path).doc(value.id),
          value.toFirestore());
    });
  }

  void _createDefaultAccountTypesCollection(WriteBatch batch) {
    const path = 'default_account_types';

    final Map<String, IModal> preData = <String, IModal>{
      "vietinbank": ModalAccountType(
          id: 'vietinbank',
          color: Colors.blue,
          image: 'asset/image/bank/vietinbank.png',
          name: 'Vietinbank',
          localAsset: true),
      "vietcombank": ModalAccountType(
          id: 'vietcombank',
          color: Colors.green,
          image: 'asset/image/bank/vietcombank.png',
          name: 'Vietcombank',
          localAsset: true)
    };

    preData.forEach((key, value) {
      batch.set(FirebaseFirestore.instance.collection(path).doc(value.id),
          value.toFirestore());
    });
  }

  void _createFrequencyTypesCollection(WriteBatch batch) {
    const path = 'frequency_types';

    final Map<String, IModal> preData = <String, IModal>{
      "daily": ModalFrequencyType(id: 'daily', interval: '1', name: 'Daily'),
      "weakly": ModalFrequencyType(id: 'weakly', interval: '7', name: 'Weakly'),
      "monthly":
          ModalFrequencyType(id: 'monthly', interval: '30', name: 'Monthly')
    };

    preData.forEach((key, value) {
      batch.set(FirebaseFirestore.instance.collection(path).doc(value.id),
          value.toFirestore());
    });
  }

  void _createDefaultCategoryTypesCollection(WriteBatch batch) {
    const path = 'default_category_types';

    final Map<String, IModal> preData = <String, IModal>{
      "shopping": ModalCategoryType(
          id: 'shopping',
          color: Colors.orange,
          image: 'asset/image/category/shopping_bag.png',
          name: 'Shopping',
          localAsset: true),
      "money": ModalCategoryType(
          id: 'money',
          color: Colors.cyan,
          image: 'asset/image/category/money_bag.png',
          name: 'Money',
          localAsset: true),
      "bill": ModalCategoryType(
          id: 'bill',
          color: Colors.red,
          image: 'asset/image/category/bill.png',
          name: 'Bill',
          localAsset: true)
    };

    preData.forEach((key, value) {
      batch.set(FirebaseFirestore.instance.collection(path).doc(value.id),
          value.toFirestore());
    });
  }

  void _createCurrencyTypesCollection(WriteBatch batch) {
    const path = 'currency_types';

    final Map<String, IModal> preData = <String, IModal>{
      "dollar": ModalCurrencyType(
          id: 'dollar',
          coefficient: 1.0,
          currencyCode: '\$',
          currencyName: 'Dollar'),
      "vietnam_dong": ModalCurrencyType(
          id: 'vietnam_dong',
          coefficient: 23325,
          currencyCode: 'VNĐ',
          currencyName: 'Việt Nam đồng')
    };

    preData.forEach((key, value) {
      batch.set(FirebaseFirestore.instance.collection(path).doc(value.id),
          value.toFirestore());
    });
  }
}
