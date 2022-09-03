import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalBudget extends IModal {
  double? budget;
  DocumentReference? categoryTypeRef;
  DateTime? timeCreate;
  double? percentAlert;

  ModalBudget(
      {required super.id,
      required this.budget,
      required this.percentAlert,
      required this.timeCreate,
      required this.categoryTypeRef});

  ModalBudget.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    budget = data?['budget'];
    categoryTypeRef = data?['category_type_ref'];
    timeCreate = DateTime.fromMillisecondsSinceEpoch(
        (data?['time_create'] as Timestamp).millisecondsSinceEpoch);
    percentAlert = data?['percent_alert'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'budget': budget,
      'category_type_ref': categoryTypeRef,
      'time_create': timeCreate,
      'percent_alert': percentAlert
    };
  }

  Map<String, dynamic> updateFirestore() {
    return {'budget': budget, 'percent_alert': percentAlert};
  }

  double remainMoney(double currentMoney) {
    double sub = budget ?? 0 - currentMoney;
    return sub < 0 ? 0 : sub;
  }

  double get percent => percentAlert ?? 0.0;

  bool isExceedLimit(double currentMoney) {
    if (percentAlert != null) {
      return currentMoney - (budget ?? 0.0) > 0 ? true : false;
    }
    return false;
  }
}
