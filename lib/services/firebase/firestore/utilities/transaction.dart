import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:path/path.dart';

class TransactionUtilities {
  String getPathStorage(String? uid, String? id, String? nameFile) =>
      'attachments/user_$uid/$id/$nameFile';
  Future<bool> add(ModalTransaction modal) async {
    try {
      TransactionFirestore instanceTransaction = TransactionFirestore();
      CurrentTransaction instanceTransactionLog = CurrentTransaction();
      await instanceTransaction.insert(modal);

      if (modal.attachments != null && modal.attachments!.isNotEmpty) {
        Set<String> uploadFile = <String>{};
        for (int index = 0; index < modal.attachments!.length; index++) {
          uploadFile.add(getPathStorage(instanceTransaction.uid, modal.id,
              basename(modal.attachments!.elementAt(index))));
          ActionFirebaseStorage.uploadFile(
              File(modal.attachments!.elementAt(index)), uploadFile.last);
        }

        modal.attachments = uploadFile;

        await instanceTransaction.override_(modal);
      }
      ModalTransactionLog? log =
          await instanceTransactionLog.findTransactionLog(modal);
      if (log == null) {
        instanceTransactionLog.insert(ModalTransactionLog(
            id: modal.id,
            firstTransactionRef: instanceTransaction.getRef(modal),
            lastTransactionRef: null));
      } else {
        log.lastTransactionRef = instanceTransaction.getRef(modal);
        instanceTransactionLog.update(log, log);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
