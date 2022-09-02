import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal.dart';

class ModalCategoryType extends IModal {
  String? name;
  String? image;
  Color? color;
  bool? localAsset;

  ModalCategoryType(
      {required super.id,
      required this.name,
      required this.image,
      required this.color,
      required this.localAsset});

  ModalCategoryType.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : super.fromFirestore(snapshot, options) {
    Map<String, dynamic>? data = snapshot.data();
    color = Color(data?['color']);
    image = data?['image'];
    name = data?['name'];
    localAsset = data?['local_asset'];
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'color': color?.value,
      'image': image,
      'name': name,
      'local_asset': localAsset
    };
  }

  @override
  Map<String, dynamic> updateFirestore() => toFirestore();

  @override
  String toString() =>
      "${name?[0].toUpperCase()}${name?.substring(1).toLowerCase()}";

  @override
  bool operator ==(dynamic other) =>
      other != null && other is ModalCategoryType && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
