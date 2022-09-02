import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/constants/enum/enum_frequency.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';

enum CRUD { create, read, update, delete }

class DataSample {
  static List<ModalTransaction>? _sample;
  static List<ModalTransaction> instanceSample() {
    _sample ??= List<ModalTransaction>.generate(300, (index) {
      return ModalTransaction(
          id: null,
          categoryTypeRef: null,
          money: index * 3.131592,
          timeCreate: DateTime.tryParse(
              "2022-0${Random().nextInt(9) + 1}-0${Random().nextInt(9) + 1}T0${Random().nextInt(9) + 1}:12:50+07:00"),
          transactionTypeRef: null,
          accountRef: null,
          purpose: "Purpose ${index % 10}",
          description: "Đoán xem id:$index",
          attachments: [],
          repeat: {
            'frequency_type_ref': '',
            'end_after': DateTime.tryParse("2023-01-01 00:00:00Z")
          },
          transactionRef: null);
    });
    return _sample!;
  }

  static String _getDate(DateTime date) =>
      "${date.year}-${date.month >= 10 ? date.month : "0${date.month}"}-${date.day >= 10 ? date.day : "0${date.day}"}";

  static SplayTreeMap<String, List<ModalTransaction>?> filterByDateTime(
      List<ModalTransaction> data) {
    Map<String, List<ModalTransaction>?> result =
        <String, List<ModalTransaction>?>{};

    for (int index = 0; index < data.length; index++) {
      String key = _getDate(data[index].timeCreate!);
      if (result.containsKey(key)) {
        result[key]!.add(data[index]);
      } else {
        result.addAll({
          key: [data[index]]
        });
      }
    }
    return SplayTreeMap<String, List<ModalTransaction>?>.from(result,
        (key1, key2) => DateTime.parse(key1).compareTo(DateTime.parse(key2)));
  }

  static DataSample? _instance;

  static DataSample instance() {
    _instance ??= DataSample();
    return _instance!;
  }

  DataSample() {
    _listenController.stream.listen((event) {
      event.forEach((key, value) {
        switch (key) {
          case CRUD.create:
            instanceSample().add(value!);
            break;
          case CRUD.read:
            break;
          case CRUD.update:
            break;
          case CRUD.delete:
            instanceSample().remove(value);
            break;
        }
      });

      _stateController.sink.add(instanceSample());
    });
  }

  Stream<List<ModalTransaction>> get stateStream => _stateController.stream;

  void addTransaction(ModalTransaction modal) async {
    _listenController.sink.add({CRUD.create: modal});
  }

  void removeTransaction(ModalTransaction modal) async {
    _listenController.sink.add({CRUD.delete: modal});
  }

  void updateTransaction(ModalTransaction was, ModalTransaction update) async {
    _listenController.sink.add({CRUD.update: was.update(update)});
  }

  void callRenderTransaction() async {
    _stateController.sink.add(instanceSample());
  }

  StreamController<Map<CRUD, ModalTransaction?>> _listenController =
      StreamController<Map<CRUD, ModalTransaction?>>.broadcast(sync: true);
  StreamController<List<ModalTransaction>> _stateController =
      StreamController<List<ModalTransaction>>.broadcast(sync: true);
}
