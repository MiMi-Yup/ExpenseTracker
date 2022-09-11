import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_frequency_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:expense_tracker/services/firebase/firestore/currency_types.dart';
import 'package:expense_tracker/services/firebase/firestore/frequency_types.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/repeat_component.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:expense_tracker/widgets/edit_date_time.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditTransaction extends StatefulWidget {
  const AddEditTransaction({Key? key}) : super(key: key);

  @override
  State<AddEditTransaction> createState() => _AddEditTransactionState();
}

class _AddEditTransactionState extends State<AddEditTransaction> {
  late double height = MediaQuery.of(context).size.height;

  ModalTransactionType? modalTransactionType;
  late final Object? _argument = ModalRoute.of(context)?.settings.arguments;
  ModalTransaction? originModal;
  late ModalTransaction modal = _argument is ModalTransaction
      ? ModalTransaction.clone((originModal = _argument as ModalTransaction))
      : ModalTransaction.minInit(
          transactionTypeRef: _argument as DocumentReference);

  ModalCategoryType? choseCategoryType;
  ModalAccount? choseAccount;

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
    if (subTitle != null) {
      items.addAll([
        SizedBox(height: 4.0),
        Text(
          subTitle,
          style: TextStyle(color: colorSubTitle),
        )
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  String convertTime(TimeOfDay? time) {
    if (time != null) {
      int hour = time.hour;
      int minute = time.minute;
      bool isPM = hour >= 12;
      hour = hour > 12 ? hour - 12 : hour;

      return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute} ${isPM ? "PM" : "AM"}";
    }
    return '';
  }

  Future<Map<String, dynamic>?> _setRepeat(
      {required BuildContext context, Map<String, dynamic>? preData}) async {
    ModalFrequencyType? choseFrequencyType;
    DateTime? endDate;
    TimeOfDay? endTime;

    if (preData != null) {
      choseFrequencyType = await FrequencyTypesFirestore()
          .getModalFromRef(preData['frequency_type_ref']);
      endDate = DateTime.fromMillisecondsSinceEpoch(
          (preData['end_after'] as Timestamp).millisecondsSinceEpoch);
      endTime = TimeOfDay(hour: endDate.hour, minute: endDate.minute);
    } else {
      endDate = DateTime.now();
      endTime = TimeOfDay.now();
    }

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
                            FutureBuilder<List<ModalFrequencyType>>(
                              future: FrequencyTypesFirestore().read(),
                              initialData: [],
                              builder: (context, snapshot) =>
                                  DropDown<ModalFrequencyType>(
                                      hint: "Frequency repeat",
                                      items: snapshot.data!,
                                      hintColor: Colors.cyan,
                                      choseValue: snapshot.hasData
                                          ? choseFrequencyType
                                          : null,
                                      onChanged: (value) =>
                                          choseFrequencyType = value).builder(),
                            ),
                            Text(
                              "End after",
                              style: TextStyle(color: Colors.grey),
                            ),
                            editDateTime(
                                icon: Icons.calendar_month,
                                value:
                                    '${endDate?.year}/${endDate?.month}/${endDate?.day}',
                                onPressed: () async => showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now())
                                    .then((value) =>
                                        setState(() => endDate = value))),
                            editDateTime(
                                icon: Icons.timer_sharp,
                                value: convertTime(endTime),
                                onPressed: () async => showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) =>
                                        setState(() => endTime = value)))
                          ]),
                    ),
                  ),
                )));
    return choseFrequencyType == null
        ? null
        : {
            'frequency_type_ref':
                FrequencyTypesFirestore().getRef(choseFrequencyType!),
            'end_after': Timestamp.fromDate(DateTime(endDate!.year,
                endDate!.month, endDate!.day, endTime!.hour, endTime!.minute))
          };
  }

  bool? isLoaded;

  Future<bool> loadData() async {
    if (isLoaded == null) {
      isLoaded = true;
      modalTransactionType = TranasactionTypeInstance.instance()
          .getModal(modal.transactionTypeRef!.id);
      if (originModal != null) {
        choseAccount =
            await AccountFirestore().getModalFromRef(modal.accountRef!);
        choseCategoryType =
            CategoryInstance.instance().getModal(modal.categoryTypeRef!.id);
      }
    }
    return isLoaded!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) => snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () =>
                          RouteApplication.navigatorKey.currentState?.pop(),
                      icon: Icon(Icons.arrow_back_ios)),
                  title: Text(modalTransactionType.toString()),
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
                                prefixText:
                                    "${UserInstance.instance().getCurrency().currencyCode} ",
                                isCollapsed: true,
                                hintText: "0.00",
                                border: InputBorder.none),
                            onChanged: (value) =>
                                modal.money = double.tryParse(value),
                            controller: TextEditingController(
                                text: "${modal.money ?? ""}"),
                          )),
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
                              EditText(
                                  onChanged: (value) => modal.purpose = value,
                                  fillText: modal.purpose,
                                  labelText: "Purpose",
                                  hintText: "Purpose"),
                              SizedBox(height: 8.0),
                              EditText(
                                  onChanged: (value) =>
                                      modal.description = value,
                                  fillText: modal.description,
                                  labelText: "Description",
                                  hintText: "Description"),
                              FutureBuilder<List<ModalCategoryType>>(
                                future: CategoryTypeFirebase().read(),
                                initialData: [],
                                builder: (context, snapshot) =>
                                    DropDown<ModalCategoryType>(
                                            hint: "Choose category",
                                            items: snapshot.data!,
                                            choseValue: choseCategoryType,
                                            onChanged: (value) =>
                                                choseCategoryType = value)
                                        .builder(),
                              ),
                              FutureBuilder<List<ModalAccount>>(
                                future: AccountFirestore().read(),
                                initialData: [],
                                builder: (context, snapshot) =>
                                    DropDown<ModalAccount>(
                                        hint: "Choose account",
                                        items: snapshot.data!,
                                        choseValue: choseAccount,
                                        onChanged: (value) =>
                                            choseAccount = value).builder(),
                              ),
                              (modal.attachments == null ||
                                      modal.attachments!.isEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          List<String?>? picker =
                                              await _filePicker();
                                          if (picker != null) {
                                            setState(() {
                                              if (modal.attachments == null) {
                                                modal.attachments =
                                                    Set.from(picker);
                                              } else {
                                                modal.attachments
                                                    ?.addAll(Set.from(picker));
                                              }
                                            });
                                          }
                                        },
                                        child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(20.0),
                                            dashPattern: [5, 5],
                                            color: Colors.grey,
                                            strokeWidth: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        IconAsset.attachment),
                                                    Text("Add attachments")
                                                  ]),
                                            )),
                                      ),
                                    )
                                  : SizedBox(
                                      height: height / 5,
                                      child: ListView(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        children: modal.attachments!
                                            .map<Widget>((e) => GestureDetector(
                                                onTap: () => setState(() {
                                                      modal.attachments
                                                          ?.remove(e);
                                                    }),
                                                child: showImageAttachments(e)))
                                            .toList()
                                          ..add(GestureDetector(
                                            onTap: () async {
                                              List<String?>? picker =
                                                  await _filePicker();
                                              if (picker != null) {
                                                setState(() {
                                                  if (modal.attachments ==
                                                      null) {
                                                    modal.attachments =
                                                        Set.from(picker);
                                                  } else {
                                                    modal.attachments?.addAll(
                                                        Set.from(picker));
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
                                              alignment: Alignment.center,
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey),
                                              child: Icon(Icons.add),
                                            ),
                                          ))
                                          ..add(GestureDetector(
                                            onTap: () async {
                                              List<String?>? picker =
                                                  await _filePicker();
                                              if (picker != null) {
                                                setState(() {
                                                  if (modal.attachments ==
                                                      null) {
                                                    modal.attachments =
                                                        Set.from(picker);
                                                  } else {
                                                    modal.attachments?.clear();
                                                    modal.attachments?.addAll(
                                                        Set.from(picker));
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
                                              alignment: Alignment.center,
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey),
                                              child: Icon(Icons.remove),
                                            ),
                                          )),
                                      ),
                                    ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Repeat"),
                                      SizedBox(height: 4.0),
                                      Text(
                                        "Repeat transaction, set your own time",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      )
                                    ],
                                  ),
                                  Switch(
                                      value: modal.repeat != null,
                                      onChanged: (value) async {
                                        if (modal.repeat == null) {
                                          modal.repeat = await _setRepeat(
                                              context: context);
                                          if (modal.repeat == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                        "Frequency hasn't selected yet")));
                                          }
                                        } else {
                                          modal.repeat = null;
                                        }
                                        setState(() {});
                                      })
                                ],
                              ),
                              Visibility(
                                  visible: modal.repeat != null,
                                  child: modal.repeat != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            if (modal.repeat != null)
                                              RepeatComponent(
                                                  map: modal.repeat),
                                            TextButton(
                                                onPressed: () async {
                                                  modal.repeat =
                                                      await _setRepeat(
                                                          context: context,
                                                          preData:
                                                              modal.repeat);
                                                  if (modal.repeat == null) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            content: Text(
                                                                "Frequency hasn't selected yet")));
                                                  }
                                                  setState(() {});
                                                },
                                                child: Text("Edit"))
                                          ],
                                        )
                                      : SizedBox()),
                              SizedBox(
                                  width: double.maxFinite,
                                  child: largestButton(
                                      text: "Continue",
                                      onPressed: () async {
                                        if (choseAccount == null ||
                                            choseCategoryType == null ||
                                            modal.money == null ||
                                            modal.purpose == null ||
                                            modal.purpose!.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please fill field")));
                                        } else {
                                          modal.accountRef = AccountFirestore()
                                              .getRef(choseAccount!);
                                          modal.categoryTypeRef =
                                              CategoryTypeFirebase()
                                                  .getRef(choseCategoryType!);
                                          modal.timeCreate = Timestamp.now();

                                          bool isSuccess =
                                              await TransactionUtilities().add(
                                                  modal,
                                                  didEditModal: originModal);

                                          originModal?.override_(modal);
                                        }
                                        // File image = File(pathImage!);
                                        // await showDialog(
                                        //   context: context,
                                        //   builder: (context) => Dialog(
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10.0)),
                                        //     child: Container(
                                        //       padding: EdgeInsets.all(10.0),
                                        //       width: 300,
                                        //       height: 50,
                                        //       color: Colors.black,
                                        //       child: StreamBuilder<TaskSnapshot>(
                                        //           builder: (context, snapshot) {
                                        //             if (snapshot.data != null) {
                                        //               TaskState state =
                                        //                   snapshot.data!.state;
                                        //               switch (state) {
                                        //                 case TaskState.running:
                                        //                   return ClipRRect(
                                        //                     borderRadius:
                                        //                         BorderRadius.all(
                                        //                             Radius.circular(
                                        //                                 10)),
                                        //                     child:
                                        //                         LinearProgressIndicator(
                                        //                       value: snapshot.data!
                                        //                               .bytesTransferred /
                                        //                           snapshot
                                        //                               .data!.totalBytes,
                                        //                       valueColor:
                                        //                           AlwaysStoppedAnimation<
                                        //                                   Color>(
                                        //                               Color(
                                        //                                   0xff00ff00)),
                                        //                       backgroundColor:
                                        //                           Color(0xffD6D6D6),
                                        //                     ),
                                        //                   );
                                        //                 case TaskState.canceled:
                                        //                   break;
                                        //                 case TaskState.paused:
                                        //                   break;
                                        //                 case TaskState.success:
                                        //                   RouteApplication
                                        //                       .navigatorKey.currentState
                                        //                       ?.pop();
                                        //                   break;
                                        //                 case TaskState.error:
                                        //                   break;
                                        //               }
                                        //             }
                                        //             return SizedBox();
                                        //           },
                                        //           initialData: null,
                                        //           stream: AccountTypeUtilities()
                                        //               .add(image, modal)),
                                        //     ),
                                        //   ),
                                        // );

                                        // showDialog(
                                        //   builder: (context) => Dialog(
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10.0)),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.all(16.0),
                                        //       child: Column(
                                        //         mainAxisSize: MainAxisSize.min,
                                        //         children: [
                                        //           Image.asset(
                                        //             IconAsset.success,
                                        //             scale: 2,
                                        //           ),
                                        //           SizedBox(height: 16.0),
                                        //           Text(
                                        //               "Transaction has been successfully added")
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        //   context: context,
                                        // );

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
                                            () => RouteApplication
                                                .navigatorKey.currentState
                                                ?.pop());
                                      },
                                      background: modalTransactionType?.color ??
                                          MyColor.purple()))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Text("Wait"),
              ));
  }

  Widget showImageAttachments(String path) {
    if (File(path).existsSync()) {
      return Image.file(File(path));
    } else {
      return FutureBuilder<Uint8List?>(
        future: ActionFirebaseStorage.downloadFile(path),
        builder: (context, snapshot) =>
            snapshot.hasData ? Image.memory(snapshot.data!) : SizedBox(),
      );
    }
  }

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String getPathStorage(String? uid, String? id, String? nameFile) =>
      'attachments/user_$uid/$id/$nameFile';

  Future<List<String?>?> _filePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      return result.paths;
    } else {
      return null;
    }
  }
}
