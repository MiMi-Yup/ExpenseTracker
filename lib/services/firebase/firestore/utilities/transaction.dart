import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
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

  Future<Map<ModalTransactionType, List<ModalTransaction>?>>
      groupTransactionByTransactionType({DateTime? filterByDate}) async {
    List<ModalTransactionLog>? logs = await _serviceLog.read();
    Map<ModalTransactionType, List<ModalTransaction>?> result = {};
    DateTime? filterDate = filterByDate == null
        ? null
        : DateTime(filterByDate.year, filterByDate.month, 1);

    if (logs != null) {
      for (ModalTransactionLog log in logs) {
        ModalTransaction? modal = await _serviceTransaction.getModalFromRef(
            log.lastTransactionRef ?? log.firstTransactionRef!);
        if (modal != null) {
          DateTime timeCreate = modal.getTimeCreate!;
          DateTime startMonthTimeCreate =
              DateTime(timeCreate.year, timeCreate.month, 1);
          if (filterDate == null ||
              filterDate.compareTo(startMonthTimeCreate) == 0) {
            ModalTransactionType? modalType =
                TranasactionTypeInstance.instance()
                    .getModal(modal.transactionTypeRef!.id);
            if (modalType != null) {
              if (result.containsKey(modalType)) {
                result[modalType]?.add(modal);
              } else {
                result.addAll({
                  modalType: [modal]
                });
              }
            }
          }
        }
      }
    }

    return result;
  }

  String _getDate(DateTime date) =>
      "${date.year}-${date.month >= 10 ? date.month : "0${date.month}"}-${date.day >= 10 ? date.day : "0${date.day}"}";

  Future<Map<String, List<ModalTransaction>?>> getTransactionByAccount(
      ModalAccount accountModal) async {
    List<ModalTransactionLog>? logs = await _serviceLog.read();
    Map<String, List<ModalTransaction>?> result = {};

    if (logs != null) {
      for (ModalTransactionLog log in logs) {
        ModalTransaction? currerntModal = log.lastTransactionRef == null
            ? null
            : await _serviceTransaction
                .getModalFromRef(log.lastTransactionRef!);
        ModalTransaction? firstModal =
            await _serviceTransaction.getModalFromRef(log.firstTransactionRef!);
        ModalTransaction? push = currerntModal ?? firstModal;

        if (push != null && push.accountRef?.id == accountModal.id) {
          String key = _getDate(firstModal!.getTimeCreate!);
          if (result.containsKey(key)) {
            result[key]!.add(push);
          } else {
            result.addAll({
              key: [push]
            });
          }
        }
      }
    }

    return result;
  }
}
