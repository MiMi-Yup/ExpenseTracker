import 'package:expense_tracker/constant/asset/icon.dart';
import 'package:flutter/material.dart';

class OverviewTransaction {
  String type;
  String? assetImage;
  Color? backgroundColor;
  double? value;
  String? currency;
  OverviewTransaction(this.type, {this.value, this.currency}) {
    switch (type.toLowerCase()) {
      case "income":
        assetImage = IconAsset.income;
        backgroundColor = const Color.fromARGB(255, 0, 168, 106);
        break;
      case "expense":
        assetImage = IconAsset.expense;
        backgroundColor = const Color.fromARGB(255, 253, 60, 73);
        break;
    }
  }
}

GestureDetector overviewTransaction({required OverviewTransaction typeTransaction, void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: typeTransaction.backgroundColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0), color: Colors.white),
              child: Image.asset(typeTransaction.assetImage!),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(typeTransaction.type.toUpperCase()),
                Text(
                  "${typeTransaction.currency}${typeTransaction.value}",
                  style: const TextStyle(fontSize: 20.0),
                )
              ],
            )
          ],
        )),
  );
}
