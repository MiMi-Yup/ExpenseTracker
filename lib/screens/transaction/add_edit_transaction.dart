import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/instances/data.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:expense_tracker/widgets/edit_date_time.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditTransaction extends StatefulWidget {
  const AddEditTransaction({Key? key}) : super(key: key);

  @override
  State<AddEditTransaction> createState() => _AddEditTransactionState();
}

class _AddEditTransactionState extends State<AddEditTransaction> {
  final itemWallets = ["MoMo", "Vietinbank", "Vietcombank"];

  late double height = MediaQuery.of(context).size.height;
  late final Object? _argument = ModalRoute.of(context)?.settings.arguments;
  // late ModalTransaction modal = _argument is ModalTransaction
  //     ? ModalTransaction.clone(_argument as ModalTransaction)
  //     : ModalTransaction.minInit(
  //         typeTransaction: _argument as ETypeTransaction);
  late ModalTransaction modal = _argument is ModalTransaction
      ? ModalTransaction.clone(_argument as ModalTransaction)
      : ModalTransaction.minInit(transactionTypeRef: null);

  String? selectedCategory;
  String? selectedWallet;
  String? description;
  String? purpose;
  bool isRepeated = false;

  //demo attachments
  List<String>? itemattachmentss;

  Widget _frequencyRepeat(
      {required String title,
      String? subTitle,
      Color? colorTitle,
      Color? colorSubTitle}) {
    List<Widget> items = [
      Text(
        title,
        style: TextStyle(color: colorTitle),
      )
    ];
    if (subTitle != null)
      items.add(Text(
        subTitle,
        style: TextStyle(color: colorSubTitle),
      ));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Object?> _setRepeat({required BuildContext context}) async {
    String? selectedFrequency;
    DateTime? startD, endD;
    TimeOfDay? startT, endT;

    await showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) => SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  reverse: true,
                  child: Container(
                    padding: MediaQuery.of(context).viewInsets,
                    decoration: BoxDecoration(
                        color: MyColor.mainBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Frequency",
                              style: TextStyle(color: Colors.grey),
                            ),
                            DropDown<String>(
                                hint: "Frequency repeat",
                                items: ["Daily", "Monthly", "Yearly"],
                                hintColor: Colors.cyan,
                                chosenValue: selectedFrequency,
                                onChanged: (value) =>
                                    setState(() => selectedFrequency = value)),
                            Text(
                              "Start from",
                              style: TextStyle(color: Colors.grey),
                            ),
                            editDateTime(
                                icon: Icons.calendar_month,
                                value: DateTime.now().toString(),
                                onPressed: () async => showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now())
                                    .then((value) => startD = value)),
                            editDateTime(
                                icon: Icons.timer_sharp,
                                value: TimeOfDay.now().toString(),
                                onPressed: () async => showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) => startT = value)),
                            Text(
                              "End after",
                              style: TextStyle(color: Colors.grey),
                            ),
                            editDateTime(
                                icon: Icons.calendar_month,
                                value: DateTime.now().toString(),
                                onPressed: () async => showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now())
                                    .then((value) => endD = value)),
                            editDateTime(
                                icon: Icons.timer_sharp,
                                value: TimeOfDay.now().toString(),
                                onPressed: () async => showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) => endT = value))
                          ]),
                    ),
                  ),
                )));
    return startD;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () => Navigator.pop(context),
      //       icon: Icon(Icons.arrow_back_ios)),
      //   title: Text(
      //       "${modal.typeTransaction?.name[0].toUpperCase()}${modal.typeTransaction?.name.substring(1).toLowerCase()}"),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: MyColor.mainBackgroundColor,
      // ),
      bottomSheet: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "How much",
                style: TextStyle(fontSize: 25.0, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 40.0),
                decoration: InputDecoration(
                    prefixText: "\$",
                    isCollapsed: true,
                    hintText: "\0.00",
                    border: InputBorder.none),
                onChanged: (value) => modal.money = double.tryParse(value),
                controller: TextEditingController(text: "${modal.money ?? ""}"),
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
                    // dropDown(
                    //     hintText: "Choose category",
                    //     items: ECategory.values
                    //         .map((e) =>
                    //             "${e.name[0].toUpperCase()}${e.name.substring(1).toLowerCase()}")
                    //         .toList(),
                    //     chosenValue: modal.category != null
                    //         ? "${modal.category?.name[0].toUpperCase()}${modal.category?.name.substring(1).toLowerCase()}"
                    //         : null,
                    //     onChanged: (value) => setState(() => modal.category =
                    //         value != null
                    //             ? ECategory.values.firstWhere((element) =>
                    //                 element.name == value.toLowerCase())
                    //             : null)),
                    EditText(
                        onChanged: (value) => modal.purpose = value,
                        fillText: modal.purpose,
                        labelText: "Purpose",
                        hintText: "Purpose"),
                    EditText(
                        onChanged: (value) => modal.description = value,
                        fillText: modal.description,
                        labelText: "Description",
                        hintText: "Description"),
                    DropDown<String>(
                        hint: "Choose account",
                        items: itemWallets,
                        chosenValue: selectedWallet,
                        onChanged: (value) =>
                            setState(() => selectedWallet = value)),
                    (modal.attachments == null || modal.attachments!.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(allowMultiple: true);
                                if (result != null) {
                                  List<File> files = result.paths
                                      .map((path) => File(path!))
                                      .toList();
                                  setState(() => modal.attachments =
                                      files.map((e) => e.path).toList());
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(20.0),
                                  dashPattern: [5, 5],
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(IconAsset.attachment),
                                          Text("Add attachments")
                                        ]),
                                  )),
                            ),
                          )
                        : SizedBox(
                            height: height / 5,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: modal.attachments!
                                  .map<Widget>((e) => Image.file(File(e)))
                                  .toList()
                                ..add(GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.center,
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                    child: Icon(Icons.add),
                                  ),
                                )),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Repeat"),
                            Text(
                              "Repeat transaction, set your own time",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ],
                        ),
                        // Switch(
                        //     value: modal.isRepeat ?? false,
                        //     onChanged: (value) async {
                        //       await _setRepeat(context: context);
                        //       setState(() => modal.isRepeat = value);
                        //     })
                      ],
                    ),
                    Visibility(
                        visible: isRepeated,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _frequencyRepeat(
                                title: "Start from",
                                subTitle: DateTime.now().toString()),
                            _frequencyRepeat(
                                title: "End after",
                                subTitle: DateTime.now().toString()),
                            TextButton(
                                onPressed: () async =>
                                    await _setRepeat(context: context),
                                child: Text("Edit"))
                          ],
                        )),
                    SizedBox(
                        width: double.maxFinite,
                        child: largestButton(
                            text: "Continue",
                            onPressed: () {
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

                              // if (_argument is ETypeTransaction) {
                              //   modal.timeTransaction = DateTime.now();
                              //   DataSample.instance().addTransaction(modal);
                              // } else {
                              //   DataSample.instance().updateTransaction(
                              //       _argument as ModalTransaction, modal);
                              // }

                              // Storage.monitorUploadFile(
                              //     File(modal.attachments!.first));

                              Future.delayed(
                                  const Duration(seconds: 1),
                                  () => Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          _argument is ModalTransaction
                                              ? RouteApplication.getRoute(
                                                  ERoute.detailTransaction)
                                              : RouteApplication.getRoute(
                                                  ERoute.main))));
                            },
                            background: MyColor.purple()))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
