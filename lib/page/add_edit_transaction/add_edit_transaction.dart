import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker/constant/asset/icon.dart';
import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/constant/enum/enum_category.dart';
import 'package:expense_tracker/constant/enum/enum_route.dart';
import 'package:expense_tracker/page/add_edit_transaction/modal_transaction.dart';
import 'package:expense_tracker/route.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/editText.dart';
import 'package:expense_tracker/widget/edit_date_time.dart';
import 'package:expense_tracker/widget/largest_button.dart';
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
  late ModalTransaction modal = (ModalRoute.of(context)?.settings.arguments
          as ModalTransaction?) ??
      ModalTransaction.minInit(
          category: ModalRoute.of(context)?.settings.arguments as ECategory?);

  String? selectedCategory;
  String? selectedWallet;
  String? description;
  String? purpose;
  bool isRepeated = false;
  Timer? _timer;

  //demo attachment
  List<String>? itemAttachments;

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
    _timer?.cancel();
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
                            dropDown(
                                hintText: "Frequency repeat",
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
            "${modal.category?.name[0].toUpperCase()}${modal.category?.name.substring(1).toLowerCase()}"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
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
                    dropDown(
                        hintText: "Choose category",
                        items: ECategory.values
                            .map((e) =>
                                "${e.name[0].toUpperCase()}${e.name.substring(1).toLowerCase()}")
                            .toList(),
                        chosenValue: modal.category != null
                            ? "${modal.category?.name[0].toUpperCase()}${modal.category?.name.substring(1).toLowerCase()}"
                            : null,
                        onChanged: (value) => setState(() => modal.category =
                            value != null
                                ? ECategory.values.firstWhere((element) =>
                                    element.name == value.toLowerCase())
                                : null)),
                    editText(
                        onChanged: (value) => modal.purpose = value,
                        fillText: modal.purpose,
                        labelText: "Purpose",
                        hintText: "Purpose"),
                    editText(
                        onChanged: (value) => modal.description = value,
                        fillText: modal.description,
                        labelText: "Description",
                        hintText: "Description"),
                    dropDown(
                        hintText: "Choose account",
                        items: itemWallets,
                        chosenValue: selectedWallet,
                        onChanged: (value) =>
                            setState(() => selectedWallet = value)),
                    (modal.attachment == null || modal.attachment!.isEmpty)
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
                                  setState(() => modal.attachment =
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
                                          Text("Add attachment")
                                        ]),
                                  )),
                            ),
                          )
                        : SizedBox(
                            height: height / 5,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: modal.attachment!
                                  .map((e) => Text(
                                        e.substring(0, 5),
                                        style: TextStyle(color: Colors.white),
                                      ))
                                  .toList(),
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
                        Switch(
                            value: modal.isRepeat ?? false,
                            onChanged: (value) async {
                              await _setRepeat(context: context);
                              setState(() => modal.isRepeat = value);
                            })
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

                              _timer = Timer(
                                  const Duration(seconds: 1),
                                  () => Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          RouteApplication.getRoute(
                                              ERoute.detailTransaction))));
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
