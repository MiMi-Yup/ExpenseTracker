import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditTransactionTypes extends StatefulWidget {
  const EditTransactionTypes({Key? key}) : super(key: key);

  @override
  State<EditTransactionTypes> createState() => _EditTransactionTypesState();
}

class _EditTransactionTypesState extends State<EditTransactionTypes> {
  late double height = MediaQuery.of(context).size.height;
  late Object? arguments = ModalRoute.of(context)?.settings.arguments;
  late ModalTransactionType modal = arguments != null
      ? arguments as ModalTransactionType
      : throw ArgumentError.notNull(
          "Required argument ModalTransactionType to call");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColor.mainBackgroundColor,
          title: Text("Account Types"),
          centerTitle: true,
        ),
        bottomSheet: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Name transaction type",
                    style: TextStyle(fontSize: 25.0, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 40.0),
                    decoration: InputDecoration(
                        isCollapsed: true,
                        hintStyle: TextStyle(color: Colors.white),
                        hintText:
                            '${modal.name?[0].toUpperCase()}${modal.name?.substring(1).toLowerCase()}',
                        border: InputBorder.none),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                child: Text(
                              "Color selected",
                              style: TextStyle(fontSize: 18),
                            )),
                            Flexible(
                              child: GestureDetector(
                                child: Container(
                                  height: height * 0.05,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: modal.color,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ),
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Container(
                                          height: height / 2.25,
                                          padding: EdgeInsets.all(10.0),
                                          child: ColorPicker(
                                              pickerAreaHeightPercent: 0.5,
                                              pickerColor: Colors.cyan,
                                              onColorChanged: (value) =>
                                                  setState(() {
                                                    modal.color = value;
                                                  })),
                                        ))),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Operator", style: TextStyle(fontSize: 18)),
                              Text(modal.operator!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Container(
                            width: double.maxFinite,
                            child: largestButton(
                                text: "Continue",
                                onPressed: () async {
                                  await TransactionTypeFirestore()
                                      .update(modal, modal);

                                  showDialog(
                                    builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              IconAsset.success,
                                              scale: 2,
                                            ),
                                            SizedBox(height: 16.0),
                                            Text(
                                                "Transaction has been successfully added")
                                          ],
                                        ),
                                      ),
                                    ),
                                    context: context,
                                  );

                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    int count = 0;
                                    RouteApplication.navigatorKey.currentState
                                        ?.popUntil((route) => count++ == 2);
                                  });
                                },
                                background: MyColor.purple()))
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
