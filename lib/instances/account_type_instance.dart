import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountTypeInstance {
  static AccountTypeInstance? _instance;
  static AccountTypeFirestore? _service;
  static List<ModalAccountType?>? _modals;
  static StreamSubscription<QuerySnapshot>? _streamSubscriptionAccountType;
  static StreamSubscription<User?>? _streamSubscriptionUser;

  static AccountTypeInstance instance({bool renew = false}) {
    if (_instance != null && renew) {
      _streamSubscriptionAccountType?.cancel();
      _streamSubscriptionUser?.cancel();
      _instance = null;
      _service = null;
      _modals = null;
    }

    if (_instance == null) {
      _instance = AccountTypeInstance();
      _streamSubscriptionUser =
          FirebaseAuth.instance.userChanges().listen((event) {
        if (event == null) {
          _streamSubscriptionAccountType?.cancel();
          _service = null;
          _modals = null;
        } else {
          _service ??= AccountTypeFirestore();
          _streamSubscriptionAccountType = _service!
              .getFirebaseRef()
              .snapshots(includeMetadataChanges: true)
              .listen((event) async {
            _modals = null;
            _modals = await _service?.read();
          }, onError: (error) {});
        }
      }, onError: (error) {});
    }

    return _instance!;
  }

  ModalAccountType? getModal(String id) =>
      _modals?.singleWhere((element) => element?.id == id);

  List<ModalAccountType?>? get modals => _modals;
}
