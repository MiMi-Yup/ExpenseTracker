import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TranasactionTypeInstance {
  static TransactionTypeFirestore? _service;
  static List<ModalTransactionType?>? _modals;
  static TranasactionTypeInstance? _instance;
  static StreamSubscription<QuerySnapshot>? _streamSubscriptionTransactionType;

  static TranasactionTypeInstance instance({bool renew = false}) {
    if (_instance != null && renew) {
      _streamSubscriptionTransactionType?.cancel();
      _instance = null;
      _modals = null;
      _service = null;
    }

    if (_instance == null) {
      _instance = TranasactionTypeInstance();
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          _streamSubscriptionTransactionType?.cancel();
          _service = null;
          _modals = null;
        } else {
          _service ??= TransactionTypeFirestore();
          _streamSubscriptionTransactionType = _service!
              .getFirebaseRef()
              .snapshots(includeMetadataChanges: true)
              .listen((event) async {
            _modals = await _service?.read();
          }, onError: (error) {});
        }
      }, onError: (error) {});
    }

    return _instance!;
  }

  ModalTransactionType? getModal(String id) {
    return _modals?.singleWhere((element) => element?.id == id);
  }

  List<ModalTransactionType?>? get modals => _modals;
}
