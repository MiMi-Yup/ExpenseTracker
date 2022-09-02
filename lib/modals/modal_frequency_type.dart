import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalFrequencyType extends IModal {
  String? name;
  double? interval;

  ModalFrequencyType(
      {required super.id, required this.name, required this.interval});

  ModalFrequencyType.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    interval = double.tryParse(data?['interval']);
    name = data?['name'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {'interval': interval, 'name': name};
  }

  @override
  Map<String, dynamic> updateFirestore() => toFirestore();

  @override
  String toString() => '$name';

  @override
  bool operator ==(dynamic other) =>
      other != null && other is ModalFrequencyType && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
