import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/currency_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccountComponent extends StatelessWidget {
  ModalAccount accountModal;
  ModalAccountType? accountTypeModal;
  void Function()? onTap;
  AccountComponent({super.key, required this.accountModal, this.onTap}) {
    accountTypeModal = AccountTypeInstance.instance()
        .getModal(accountModal.accountTypeRef!.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.black.withAlpha(125),
            borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: accountTypeModal?.color?.withAlpha(25),
                    borderRadius: BorderRadius.circular(8.0)),
                alignment: Alignment.center,
                child: accountTypeModal?.localAsset == true
                    ? Image.asset(
                        accountTypeModal!.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.scaleDown,
                      )
                    : FutureBuilder<Uint8List?>(
                        future: ActionFirebaseStorage.downloadFile(
                            accountTypeModal!.image!),
                        builder: (context, snapshot) => snapshot.hasData
                            ? Image.memory(snapshot.data!)
                            : LinearProgressIndicator()),
              ),
              SizedBox(
                width: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${accountTypeModal?.name}"),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("last used")
                ],
              )
            ]),
            Text(
                "${CurrencyTypeInstance.instance().getModal(accountModal.currencyTypeRef!.id)?.currencyCode} ${accountModal.money}")
          ],
        ),
      ),
    );
  }
}
