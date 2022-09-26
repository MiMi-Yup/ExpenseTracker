import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_frequency_type.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';

class FrequencyTypesFirestore extends IFirestore {
  @override
  Future<void> delete(IModal modal) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  String getPath(String? uid) => 'frequency_types';

  @override
  Future<List<ModalFrequencyType>?> read() async {
    try {
      QuerySnapshot<ModalFrequencyType> snapshot = await FirebaseFirestore
          .instance
          .collection(getPath(user?.uid))
          .withConverter(
              fromFirestore: ModalFrequencyType.fromFirestore,
              toFirestore: (ModalFrequencyType currency, _) =>
                  currency.toFirestore())
          .get();
      return snapshot.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      return null;
    }
  }

  @override
  Future<ModalFrequencyType?> getModalFromRef(
      DocumentReference<Object?> ref) async {
    try {
      DocumentSnapshot<ModalFrequencyType> snapshot = await ref
          .withConverter(
              fromFirestore: ModalFrequencyType.fromFirestore,
              toFirestore: (ModalFrequencyType modal, _) => modal.toFirestore())
          .get();
      return snapshot.data();
    } on FirebaseException {
      return null;
    }
  }
}
