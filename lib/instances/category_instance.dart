import 'dart:ui';

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

  static CategoryInstance instance() {
    if (_instance == null) {
      _instance = CategoryInstance();
      FirebaseAuth.instance.userChanges().listen((event) {
        if (event == null) {
          _service = null;
          _modals = null;
        } else {
          _service ??= CategoryTypeFirebase();
          _service!
              .getFirebaseRef()
              .snapshots(includeMetadataChanges: true)
              .listen((event) async {
            _modals = await _service!.read();
          });
        }
      });
    }

    return _instance!;
  }

  // HintCategoryComponent getHintCategoryComponent(String id) =>
  //     HintCategoryComponent(modal: getModal(id)!);

  ModalCategoryType? getModal(String id) =>
      _modals?.singleWhere((element) => element?.id == id);

  List<ModalCategoryType?>? get modals => _modals;
}
