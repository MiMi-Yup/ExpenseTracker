import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/asset/category.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:expense_tracker/widgets/component/hint_category_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryInstance {
  static CategoryInstance? _instance;
  static CategoryTypeFirebase? _service;
  static List<ModalCategoryType?>? _modals;
  static StreamSubscription<QuerySnapshot>? _streamSubscriptionCategory;
  static StreamSubscription<User?>? _streamSubscriptionUser;

  static CategoryInstance instance({bool renew = false}) {
    if (_instance != null && renew) {
      _streamSubscriptionCategory?.cancel();
      _streamSubscriptionUser?.cancel();
      _instance = null;
      _service = null;
      _modals = null;
    }

    if (_instance == null) {
      _instance = CategoryInstance();
      _streamSubscriptionUser =
          FirebaseAuth.instance.userChanges().listen((event) {
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

  // HintCategoryComponent getHintCategoryComponent(String id) =>
  //     HintCategoryComponent(modal: getModal(id)!);

  ModalCategoryType? getModal(String id) =>
      _modals?.singleWhere((element) => element?.id == id);

  List<ModalCategoryType?>? get modals => _modals;
}
