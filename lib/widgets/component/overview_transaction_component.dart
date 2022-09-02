import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:flutter/material.dart';

class OverviewTransactionComponent extends ModalTransaction {
  static const Map<ETypeTransaction, String> _assetMap =
      <ETypeTransaction, String>{
    ETypeTransaction.income: IconAsset.income,
    ETypeTransaction.expense: IconAsset.expense
  };

  OverviewTransactionComponent(
      {required super.transactionTypeRef, double? money, String? currency})
      : super.minInit() {
    this.money = money;
    //this.currency = currency;
  }

  OverviewTransactionComponent.minInit({required super.transactionTypeRef})
      : super.minInit();

  Widget builder({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          // decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          //     color: MyColor.colorTransaction[typeTransaction]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   padding: const EdgeInsets.all(8.0),
              //   margin: const EdgeInsets.only(right: 8.0),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(16.0),
              //       color: Colors.white),
              //   child: Image.asset(_assetMap[typeTransaction]!),
              // ),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Text(typeTransaction!.name.toUpperCase()),
              //     Text(
              //       "${currency}${money}",
              //       style: const TextStyle(fontSize: 20.0),
              //     )
              //   ],
              // )
            ],
          )),
    );
  }
}
