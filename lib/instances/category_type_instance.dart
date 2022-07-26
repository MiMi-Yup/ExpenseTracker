import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryTypeInstance {
  static CategoryTypeInstance? _instance;
  static CategoryTypeFirebase? _service;
  static List<ModalCategoryType?>? _modals;
  static StreamSubscription<QuerySnapshot>? _streamSubscriptionCategory;

  static CategoryTypeInstance instance({bool renew = false}) {
    if (_instance != null && renew) {
      _streamSubscriptionCategory?.cancel();
      _instance = null;
      _service = null;
      _modals = null;
    }

    if (_instance == null) {
      _instance = CategoryTypeInstance();
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          _streamSubscriptionCategory?.cancel();
          _service = null;
          _modals = null;
        } else {
          _service ??= CategoryTypeFirebase();
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

  ModalCategoryType? getModal(String id) =>
      _modals?.singleWhere((element) => element?.id == id);

  List<ModalCategoryType?>? get modals => _modals;
}
