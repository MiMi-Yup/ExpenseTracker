import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'dart:io' show Platform;

import 'package:expense_tracker/services/id_device.dart';

class ModalUser extends IModal {
  String? displayName;
  String? email;
  String? password;
  String? phoneNumber;
  String? photoURL;
  bool? emailVerified;
  String? passcode;
  DocumentReference? currencyTypeDefaultRef;
  bool? wasSetup;
  String? lastLoginDeviceId;

  ModalUser(
      {required super.id,
      required this.displayName,
      required this.email,
      required this.password,
      this.phoneNumber,
      this.photoURL,
      this.passcode,
      required this.currencyTypeDefaultRef,
      this.emailVerified,
      required this.wasSetup,
      required this.lastLoginDeviceId});

  ModalUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    passcode = data?['passcode'];
    currencyTypeDefaultRef = data?['currency_type_default_ref'];
    wasSetup = data?['was_setup'];
    lastLoginDeviceId = data?['last_login_device_id'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'passcode': passcode,
      'currency_type_default_ref': currencyTypeDefaultRef,
      'was_setup': wasSetup,
      'last_login_device_id': lastLoginDeviceId
    };
  }

  @override
  Map<String, dynamic> updateFirestore() => {'passcode': passcode};

  bool get validation =>
      email != null &&
      password != null &&
      email!.isNotEmpty &&
      password!.isNotEmpty;

  Future<bool> get isLastLoginDevice async =>
      lastLoginDeviceId == (await IdDevice.idDevice);
}
