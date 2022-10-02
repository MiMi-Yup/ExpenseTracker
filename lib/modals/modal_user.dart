import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

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

  ModalUser(
      {required super.id,
      this.displayName,
      required this.email,
      required this.password,
      this.phoneNumber,
      this.photoURL,
      this.passcode,
      this.currencyTypeDefaultRef,
      this.emailVerified,
      this.wasSetup});

  ModalUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    passcode = data?['passcode'];
    currencyTypeDefaultRef = data?['currency_type_default_ref'];
    wasSetup = data?['was_setup'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'passcode': passcode,
      'currency_type_default_ref': currencyTypeDefaultRef,
      'was_setup': wasSetup
    };
  }

  @override
  Map<String, dynamic> updateFirestore() => {'passcode': passcode};

  bool get validation =>
      email != null &&
      password != null &&
      email!.isNotEmpty &&
      password!.isNotEmpty;
}
