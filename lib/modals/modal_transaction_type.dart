import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalTransactionType extends IModal {
  Color? color;
  String? name;
  String? operator;
  String? image;
  bool? localAsset;

  ModalTransactionType(
      {required super.id,
      required this.color,
      required this.name,
      required this.operator,
      required this.image,
      required this.localAsset});

  ModalTransactionType.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    color = Color(data?['color']);
    operator = data?['operator'];
    name = data?['name'];
    image = data?['image'];
    localAsset = data?['local_asset'];
  }

  @override
  Map<String, dynamic> toFirestore() => {
        'color': color?.value,
        'operator': operator,
        'name': name,
        'image': image,
        'local_asset': localAsset
      };

  @override
  Map<String, dynamic> updateFirestore() => {
        'color': color?.value,
        'name': name,
        'image': image,
        'local_asset': localAsset
      };
}
