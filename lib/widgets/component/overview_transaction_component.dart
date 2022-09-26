import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OverviewTransactionComponent {
  ModalTransactionType? modal;
  double money;
  OverviewTransactionComponent(
      {required this.modal, required this.money});

  Widget builder({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: modal?.color),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white),
                child: modal?.localAsset == true
                    ? Image.asset(modal!.image!)
                    : FutureBuilder<Uint8List?>(
                        future:
                            ActionFirebaseStorage.downloadFile(modal!.image!),
                        initialData: null,
                        builder: (context, snapshot) => snapshot.hasData
                            ? Image.memory(
                                snapshot.data!,
                                fit: BoxFit.scaleDown,
                              )
                            : CircularProgressIndicator()),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(modal.toString()),
                  Text(
                    "${UserInstance.instance().getCurrency()?.currencyCode} ${money}",
                    style: const TextStyle(fontSize: 18.0),
                  )
                ],
              )
            ],
          )),
    );
  }
}
