import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/editText.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class AddEditTransaction extends StatefulWidget {
  const AddEditTransaction({Key? key}) : super(key: key);

  @override
  State<AddEditTransaction> createState() => _AddEditTransactionState();
}

class _AddEditTransactionState extends State<AddEditTransaction> {
  final itemCategorys = ["Food", "Drink", "Skin care"];
  final itemWallets = ["MoMo", "Vietinbank", "Vietcombank"];
  late double height = MediaQuery.of(context).size.height;
  String? selectedCategory;
  String? selectedWallet;
  String? description;
  bool isRepeated = false;

  //demo attachment
  List<String>? itemAttachments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
        title: Text("Expense"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: Column(
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
                      items: itemCategorys,
                      chosenValue: selectedCategory,
                      onChanged: (value) =>
                          setState(() => selectedCategory = value)),
                  editText(
                      onChanged: (value) => description = value,
                      fillText: description,
                      labelText: "Description",
                      hintText: "Description"),
                  dropDown(
                      items: itemWallets,
                      chosenValue: selectedWallet,
                      onChanged: (value) =>
                          setState(() => selectedWallet = value)),
                  (itemAttachments == null || itemAttachments!.isEmpty)
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
                                setState(() => itemAttachments =
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
                                        Image.asset(
                                            "asset/image/attachment.png"),
                                        Text("Add attachment")
                                      ]),
                                )),
                          ),
                        )
                      : SizedBox(
                          height: height / 5,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: itemAttachments!
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
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          )
                        ],
                      ),
                      Switch(
                          value: isRepeated,
                          onChanged: (value) async {
                            await showModalBottomSheet(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                    builder: (BuildContext context, setState) =>
                                        Container(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: []),
                                          ),
                                        )));
                            setState(() => isRepeated = value);
                          })
                    ],
                  ),
                  Visibility(visible: isRepeated, child: Row(children: [])),
                  Container(
                      width: double.maxFinite,
                      child: largestButton(
                          text: "Continue",
                          onPressed: () => null,
                          background: MyColor.purple()))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
