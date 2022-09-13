import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalBudget extends IModal {
  double? budget;
  DocumentReference? categoryTypeRef;
  Timestamp? timeCreate;
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
    timeCreate = data?['time_create'];
    percentAlert = data?['percent_alert'];
  }

  @override
  Map<String, dynamic> toFirestore() => {
        'budget': budget,
        'category_type_ref': categoryTypeRef,
        'time_create': timeCreate,
        'percent_alert': percentAlert
      };

  @override
  Map<String, dynamic> updateFirestore() => {
        'budget': budget,
        'percent_alert': percentAlert,
        'category_type_ref': categoryTypeRef
      };

  double remainMoney(double currentMoney) {
    double sub = (budget ?? 0) - currentMoney;
    return sub < 0 ? 0 : sub;
  }

  double get percent => percentAlert ?? 0.0;

  double percentBudget(double currentMoney) =>
      budget == null ? 1 : currentMoney / budget!;

  DateTime? get getTimeCreate => timeCreate?.toDate();

  bool isExceedLimit(double currentMoney) =>
      currentMoney - (budget ?? 0.0) > 0 ? true : false;

  bool isAlert(double currentMoney) {
    if (budget == null) return true;
    if (percent == 0.0) return false;
    if (currentMoney / budget! >= percent) return true;
    return false;
  }
}
