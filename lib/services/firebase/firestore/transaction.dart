import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/path_firebase_storage.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:expense_tracker/services/firebase/firestore/interface.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TransactionFirestore extends IFirestore {
  @override
  Future<void> delete(IModal modal) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(IModal modal) async {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .add(modal.toFirestore())
        .then((value) {
      modal.id = value.id;
    });
  }

  @override
  Future<List<ModalTransaction>> read() async {
    QuerySnapshot<ModalTransaction> snapshot = await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .withConverter(
            fromFirestore: ModalTransaction.fromFirestore,
            toFirestore: (ModalTransaction modal, _) => modal.toFirestore())
        .get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<void> override_(IModal modal) async {
    return FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .set(modal.toFirestore());
  }

  Future<bool> checkTransactionTypeExists(ModalTransactionType modal) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .where('transaction_type_ref',
            isEqualTo: TransactionTypeFirestore().getRef(modal))
        .get()
        .then((value) => exist = value.size > 0, onError: (e) => print(e));
    return exist;
  }

  Future<bool> checkAccountExists(ModalAccount modal) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .where('account_ref', isEqualTo: AccountFirestore().getRef(modal))
        .get()
        .then((value) => exist = value.size > 0, onError: (e) => print(e));
    return exist;
  }

  Future<bool> checkCategoryTypeExists(ModalCategoryType modal) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection(getPath(user?.uid))
        .where('category_type_ref',
            isEqualTo: CategoryTypeFirebase().getRef(modal))
        .get()
        .then((value) => exist = value.size > 0, onError: (e) => print(e));
    return exist;
  }

  Future<DocumentReference> getTransactionRef(ModalTransaction modal) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection(getPath(user?.uid))
        .doc(modal.id)
        .get();
    return doc.data()?['transaction_ref'];
  }

  @override
  String getPath(String? uid) => 'users/user_$uid/all_transactions';

  @override
  Future<ModalTransaction?> getModalFromRef(
      DocumentReference<Object?> ref) async {
    DocumentSnapshot<ModalTransaction> snapshot = await ref
        .withConverter(
            fromFirestore: ModalTransaction.fromFirestore,
            toFirestore: (ModalTransaction modal, _) => modal.toFirestore())
        .get();
    return snapshot.data();
  }
}
