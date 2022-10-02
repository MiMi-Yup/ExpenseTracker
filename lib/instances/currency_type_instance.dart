import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/services/firebase/firestore/currency_types.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrencyTypeInstance {
  static CurrencyTypeInstance? _instance;
  static CurrencyTypesFirestore? _service;
  static List<ModalCurrencyType?>? _modals;
  static StreamSubscription<QuerySnapshot>? _streamSubscriptionCategory;

  static CurrencyTypeInstance instance({bool renew = false}) {
    if (_instance != null && renew) {
      _streamSubscriptionCategory?.cancel();
      _instance = null;
      _service = null;
      _modals = null;
    }

    if (_instance == null) {
      _instance = CurrencyTypeInstance();
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          _streamSubscriptionCategory?.cancel();
          _service = null;
          _modals = null;
        } else {
          _service ??= CurrencyTypesFirestore();
          _streamSubscriptionCategory = _service!
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

  ModalCurrencyType? getModal(String id) =>
      _modals?.singleWhere((element) => element?.id == id);

  List<ModalCurrencyType?>? get modals => _modals;
}
