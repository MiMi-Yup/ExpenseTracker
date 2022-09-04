import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountTypeInstance {
  static AccountTypeInstance? _instance;
  static AccountTypeFirestore? _service;
  static List<ModalAccountType?>? _modals;

  static AccountTypeInstance instance() {
    if (_instance == null) {
      _instance = AccountTypeInstance();
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          _service = null;
          _modals = null;
        } else {
          _service ??= AccountTypeFirestore();
          _service!
              .getFirebaseRef()
              .snapshots(includeMetadataChanges: true)
              .listen((event) async {
            _modals = null;
            _modals = await _service!.read();
          });
        }
      });
    }

    return _instance!;
  }

  ModalAccountType? getModal(String id) =>
      _modals?.singleWhere((element) => element?.id == id);

  List<ModalAccountType?>? get modals => _modals;
}
