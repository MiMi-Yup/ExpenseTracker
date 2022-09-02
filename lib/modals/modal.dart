import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IModal {
  String? id;
  IModal({required this.id});

  IModal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    id = snapshot.id;
  }

  Map<String, dynamic> toFirestore();
  Map<String, dynamic> updateFirestore();
}
