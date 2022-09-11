import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';

class CurrencyTypesFirestore extends IFirestore {
  @override
  Future<void> delete(IModal modal) async {}

  @override
  String getPath(String? uid) => 'currency_types';

  @override
  Future<List<ModalCurrencyType>> read() async {
    QuerySnapshot<ModalCurrencyType> snapshot = await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalCurrencyType.fromFirestore,
            toFirestore: (ModalCurrencyType currency, _) =>
                currency.toFirestore())
        .get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<ModalCurrencyType?> getModalFromRef(
      DocumentReference<Object?> ref) async {
    DocumentSnapshot<ModalCurrencyType> snapshot = await ref
        .withConverter(
            fromFirestore: ModalCurrencyType.fromFirestore,
            toFirestore: (ModalCurrencyType modal, _) => modal.toFirestore())
        .get();
    return snapshot.data();
  }
}
