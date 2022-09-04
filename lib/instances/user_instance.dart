import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserInstance {
  static UserInstance? _instance;
  static UserFirestore? _service;
  static ModalUser? _modal;
  static ModalCurrencyType? _currency;

  static UserInstance instance() {
    if (_instance == null) {
      _instance = UserInstance();
      FirebaseAuth.instance.userChanges().listen((event) async {
        if (event == null) {
          _service = null;
          _modal = null;
          _currency = null;
        } else {
          _service ??= UserFirestore();
          List<ModalUser> modals = await _service!.read();
          _modal ??= modals[0];
          _currency ??= await _service!.getMainCurrencyAccount(modal: _modal);
        }
      });
    }

    return _instance!;
  }

  ModalCurrencyType getCurrency() {
    return _currency!;
  }

  ModalUser getModal() {
    return _modal!;
  }
}
