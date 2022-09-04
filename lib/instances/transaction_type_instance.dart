import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TranasactionTypeInstance {
  static TransactionTypeFirestore? _service;
  static List<ModalTransactionType?>? _modals;
  static TranasactionTypeInstance? _instance;

  static TranasactionTypeInstance instance() {
    if (_instance == null) {
      _instance = TranasactionTypeInstance();
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          _service = null;
          _modals = null;
        } else {
          _service ??= TransactionTypeFirestore();
          _service!
              .getFirebaseRef()
              .snapshots(includeMetadataChanges: true)
              .listen((event) async {
            _modals = null;
            _modals ??= await _service!.read();
          });
        }
      });
    }

    return _instance!;
  }

  ModalTransactionType? getModal(String id) {
    return _modals?.singleWhere((element) => element?.id == id);
  }

  List<ModalTransactionType?>? get modals => _modals;
}
