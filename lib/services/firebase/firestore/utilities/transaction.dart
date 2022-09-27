import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:path/path.dart';

class TransactionUtilities {
  final TransactionFirestore _serviceTransaction = TransactionFirestore();
  final CurrentTransactionFirestore _serviceLog = CurrentTransactionFirestore();
  String getPathStorage(String? uid, String? id, String? nameFile) =>
      'attachments/user_$uid/$id/$nameFile';

  Future<bool> add(ModalTransaction modal,
      {ModalTransaction? didEditModal}) async {
    try {
      if (didEditModal != null) {
        modal.transactionRef = _serviceTransaction.getRef(didEditModal);
      }

      await _serviceTransaction.insert(modal);

      if (modal.attachments != null && modal.attachments!.isNotEmpty) {
        Set<String> existOnFireStorage = {};
        Set<String> uploadFiles = Set.from(modal.attachments!);

        if (didEditModal != null &&
            didEditModal.attachments != null &&
            didEditModal.attachments!.isNotEmpty) {
          existOnFireStorage =
              uploadFiles.intersection(didEditModal.attachments!);
          uploadFiles.removeAll(existOnFireStorage);
        }

        for (int index = 0; index < uploadFiles.length; index++) {
          String pathFileUpload = uploadFiles.elementAt(index);

          existOnFireStorage.add(getPathStorage(_serviceTransaction.user?.uid,
              modal.id, basename(pathFileUpload)));

          ActionFirebaseStorage.uploadFile(
              File(pathFileUpload), existOnFireStorage.last);
        }

        modal.attachments =
            existOnFireStorage.isEmpty ? null : existOnFireStorage;
        await _serviceTransaction.override_(modal);
      }

      ModalTransactionLog? log = await _serviceLog.findTransactionLog(modal);
      if (log == null) {
        _serviceLog.insert(ModalTransactionLog(
            id: modal.id,
            firstTransactionRef: _serviceTransaction.getRef(modal),
            lastTransactionRef: null));
      } else {
        log.lastTransactionRef = _serviceTransaction.getRef(modal);
        _serviceLog.update(log, log);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(ModalTransaction modal) async {
    ModalTransactionLog? log = await _serviceLog.findTransactionLog(modal);
    if (log == null) {
      return true;
    } else {
      DocumentReference ref =
          log.lastTransactionRef ?? log.firstTransactionRef!;
      ModalTransaction? iterable =
          await _serviceTransaction.getModalFromRef(ref);
      while (iterable != null) {
        if (iterable.attachments != null) {
          List<String> deleteAttachments = iterable.attachments!
              .where((element) => element.contains(getPathStorage(
                  _serviceTransaction.user?.uid, iterable?.id, '')))
              .toList();

          for (String element in deleteAttachments) {
            await ActionFirebaseStorage.deleteFile(element);
          }
        }

        _serviceTransaction.delete(iterable);
        if (iterable.transactionRef != null) {
          iterable = await _serviceTransaction
              .getModalFromRef(iterable.transactionRef!);
        } else {
          break;
        }
      }

      await _serviceLog.delete(iterable!);

      return true;
    }
  }

  Future<List<ModalTransaction>?> timelineEditTransaction(
      ModalTransaction modal) async {
    List<ModalTransaction>? timeline = [];
    ModalTransaction? iterableModal;
    ModalTransactionLog? log = await _serviceLog.findTransactionLog(modal);
    if (log != null) {
      iterableModal = await _serviceTransaction
          .getModalFromRef(log.lastTransactionRef ?? log.firstTransactionRef!);
    }

    if (iterableModal != null) {
      while (iterableModal!.transactionRef != null) {
        timeline.add(iterableModal);
        iterableModal = await _serviceTransaction
            .getModalFromRef(iterableModal.transactionRef!);
      }

      timeline.add(iterableModal);
    }

    return timeline;
  }
}
