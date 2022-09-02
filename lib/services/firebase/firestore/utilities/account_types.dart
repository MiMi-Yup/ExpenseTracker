import 'dart:io';

import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AccountTypeUtilities {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String getPathStorage(String? uid, String? id, String? nameFile) =>
      'account_types/user_$uid/$id/$nameFile';
  Stream<TaskSnapshot> add(File file, ModalAccountType modal) {
    String? id = modal.id ??= modal.name?.replaceAll(' ', '_');
    String nameFile = basename(file.path);
    String pathStorage = getPathStorage(uid, id, nameFile);

    Stream<TaskSnapshot> task =
        ActionFirebaseStorage.uploadFile(file, pathStorage).snapshotEvents;

    task.listen((event) async {
      if (event.state == TaskState.success) {
        modal.image = pathStorage;
        await AccountTypeFirestore().insert(modal);
      }
    });

    return task;
  }
}
