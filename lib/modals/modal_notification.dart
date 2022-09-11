import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalNotification extends IModal {
  Timestamp? timeCreate;
  bool? isRead;
  String? title;
  String? reasonNotification;
  DocumentReference<Object?>? budgetRef;
  ModalNotification(
      {required super.id,
      required this.timeCreate,
      required this.isRead,
      required this.title,
      required this.reasonNotification,
      required this.budgetRef});

  ModalNotification.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    timeCreate = data?['time_create'];
    isRead = data?['is_read'];
    title = data?['title'];
    reasonNotification = data?['reason_notification'];
    budgetRef = data?['budget_ref'];
  }

  @override
  Map<String, dynamic> toFirestore() => {
        'time_create': timeCreate,
        'is_read': isRead,
        'title': title,
        'reason_notification': reasonNotification,
        'budget_ref': budgetRef
      };

  @override
  Map<String, dynamic> updateFirestore() => toFirestore();

  String get getTImeNotification {
    if (timeCreate != null) {
      int hour = getTimeCreate!.hour;
      int minute = getTimeCreate!.minute;
      bool isPM = hour >= 12;
      hour = hour > 12 ? hour - 12 : hour;

      return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute} ${isPM ? "PM" : "AM"}";
    }
    return "";
  }

  String get getDateTransaction => timeCreate != null
      ? "${getTimeCreate!.day}/${getTimeCreate!.month}/${getTimeCreate!.year}"
      : "";

  DateTime? get getTimeCreate => timeCreate?.toDate();
}
