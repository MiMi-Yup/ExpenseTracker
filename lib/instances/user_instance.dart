import 'dart:async';

import 'package:expense_tracker/instances/currency_type_instance.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInstance {
  static UserInstance? _instance;
  static UserFirestore? _service;
  static ModalUser? _modal;

  static UserInstance instance({bool renew = false}) {
    if (_instance != null && renew) {
      _instance = null;
      _service = null;
      _modal = null;
    }

    if (_instance == null) {
      _instance = UserInstance();
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event == null) {
          _service = null;
          _modal = null;
        } else {
          _service ??= UserFirestore();
          List<ModalUser>? modals = await _service!.read();
          _modal = modals != null && modals.isNotEmpty ? modals.first : null;
        }
      }, onError: (error) {});
    }

    return _instance!;
  }

  ModalCurrencyType? get defaultCurrencyAccount => _modal == null
      ? null
      : CurrencyTypeInstance.instance()
          .getModal(_modal!.currencyTypeDefaultRef!.id);

  ModalUser? get modal => _modal;
}
