import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:path/path.dart';

class TransactionUtilities {
  final TransactionFirestore serviceTransaction = TransactionFirestore();
  final CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();
  String getPathStorage(String? uid, String? id, String? nameFile) =>
      'attachments/user_$uid/$id/$nameFile';

  Future<bool> add(ModalTransaction modal,
      {ModalTransaction? didEditModal}) async {
    try {
      if (didEditModal != null) {
        modal.transactionRef = serviceTransaction.getRef(didEditModal);
      }

      await serviceTransaction.insert(modal);

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

          existOnFireStorage.add(getPathStorage(serviceTransaction.user?.uid,
              modal.id, basename(pathFileUpload)));

          ActionFirebaseStorage.uploadFile(
              File(pathFileUpload), existOnFireStorage.last);
        }

        modal.attachments =
            existOnFireStorage.isEmpty ? null : existOnFireStorage;
        await serviceTransaction.override_(modal);
      }

      ModalTransactionLog? log = await serviceLog.findTransactionLog(modal);
      if (log == null) {
        serviceLog.insert(ModalTransactionLog(
            id: modal.id,
            firstTransactionRef: serviceTransaction.getRef(modal),
            lastTransactionRef: null));
      } else {
        log.lastTransactionRef = serviceTransaction.getRef(modal);
        serviceLog.update(log, log);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(ModalTransaction modal) async {
    ModalTransactionLog? log = await serviceLog.findTransactionLog(modal);
    if (log == null) {
      return true;
    } else {
      DocumentReference ref =
          log.lastTransactionRef ?? log.firstTransactionRef!;
      ModalTransaction? iterable =
          await serviceTransaction.getModalFromRef(ref);
      while (iterable != null) {
        if (iterable.attachments != null) {
          List<String> deleteAttachments = iterable.attachments!
              .where((element) => element.contains(getPathStorage(
                  serviceTransaction.user?.uid, iterable?.id, '')))
              .toList();

          for (String element in deleteAttachments) {
            await ActionFirebaseStorage.deleteFile(element);
          }
        }

        serviceTransaction.delete(iterable);
        if (iterable.transactionRef != null) {
          iterable = await serviceTransaction
              .getModalFromRef(iterable.transactionRef!);
        } else {
          break;
        }
      }

      await serviceLog.delete(iterable!);

      return true;
    }
  }

  Future<List<ModalTransaction>?> timelineEditTransaction(
      ModalTransaction modal) async {
    List<ModalTransaction>? timeline = [];
    ModalTransaction? iterableModal;
    ModalTransactionLog? log = await serviceLog.findTransactionLog(modal);
    if (log != null) {
      iterableModal = await serviceTransaction
          .getModalFromRef(log.lastTransactionRef ?? log.firstTransactionRef!);
    }

    if (iterableModal != null) {
      while (iterableModal!.transactionRef != null) {
        timeline.add(iterableModal);
        iterableModal = await serviceTransaction
            .getModalFromRef(iterableModal.transactionRef!);
      }

      timeline.add(iterableModal);
    }

    return timeline;
  }
}
