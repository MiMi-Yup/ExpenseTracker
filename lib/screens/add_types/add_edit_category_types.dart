import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/constants/path_firebase_storage.dart';
import 'package:expense_tracker/modals/modal_account_type.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/account_types.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/category_types.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddEditCategoryTypes extends StatefulWidget {
  const AddEditCategoryTypes({Key? key}) : super(key: key);

  @override
  State<AddEditCategoryTypes> createState() => _AddEditCategoryTypesState();
}

class _AddEditCategoryTypesState extends State<AddEditCategoryTypes> {
  late double height = MediaQuery.of(context).size.height;
  String? pathImage;
  String? errorText;
  ModalCategoryType modal = ModalCategoryType(
      id: null, color: Colors.cyan, image: null, name: null, localAsset: false);

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          errorText = "Please type name account types";
        });
      } else {
        modal.name = controller.text;
        modal.id = modal.name?.replaceAll(' ', '_');
        setState(() {
          errorText = null;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                    "Name category type",
                    style: TextStyle(fontSize: 25.0, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 40.0),
                    decoration: InputDecoration(
                        errorText: errorText,
                        isCollapsed: true,
                        hintText: "Shopping",
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
                            Flexible(child: Text("Color selected")),
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
                            child: GestureDetector(
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(allowMultiple: false);
                                  if (result != null) {
                                    List<String?> paths = result.paths;
                                    if (paths.isNotEmpty &&
                                        paths.first != null) {
                                      setState(() {
                                        pathImage = paths.first;
                                      });
                                    }
                                  } else {
                                    //cancel picker
                                  }
                                },
                                child: pathImage == null
                                    ? DottedBorder(
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
                                                    IconAsset.attachment),
                                                Text("Add attachments")
                                              ]),
                                        ))
                                    : Container(
                                        height: height / 2.5,
                                        padding: EdgeInsets.all(10.0),
                                        alignment: Alignment.center,
                                        child: Image.file(
                                          File(pathImage!),
                                          scale: 10,
                                        )))),
                        Container(
                            width: double.maxFinite,
                            child: largestButton(
                                text: "Continue",
                                onPressed: () async {
                                  errorText = null;
                                  if (controller.text.isEmpty ||
                                      pathImage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Required name and pick image to create new")));
                                  } else {
                                    File image = File(pathImage!);
                                    await showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Container(
                                          padding: EdgeInsets.all(10.0),
                                          width: 300,
                                          height: 50,
                                          color: Colors.black,
                                          child: StreamBuilder<TaskSnapshot>(
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  TaskState state =
                                                      snapshot.data!.state;
                                                  switch (state) {
                                                    case TaskState.running:
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value: snapshot.data!
                                                                  .bytesTransferred /
                                                              snapshot.data!
                                                                  .totalBytes,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Color(
                                                                      0xff00ff00)),
                                                          backgroundColor:
                                                              Color(0xffD6D6D6),
                                                        ),
                                                      );
                                                    case TaskState.canceled:
                                                      break;
                                                    case TaskState.paused:
                                                      break;
                                                    case TaskState.success:
                                                      RouteApplication
                                                          .navigatorKey
                                                          .currentState
                                                          ?.pop();
                                                      break;
                                                    case TaskState.error:
                                                      break;
                                                  }
                                                }
                                                return SizedBox();
                                              },
                                              initialData: null,
                                              stream: CategoryTypeUtilities()
                                                  .add(image, modal)),
                                        ),
                                      ),
                                    );

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
                                  }
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
