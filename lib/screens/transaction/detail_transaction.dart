import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailTransaction extends StatefulWidget {
  DetailTransaction({Key? key}) : super(key: key);

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  late List<Object>? arguments =
      ModalRoute.of(context)?.settings.arguments as List<Object>?;
  late ModalTransaction modal = arguments?[0] as ModalTransaction;
  late bool isEditable = (arguments?[1] as bool?) ?? false;

  GlobalKey keyAppBar = GlobalKey();

  Size sizeAppBar = Size.zero;
  Offset position = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box =
          keyAppBar.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        sizeAppBar = box.size;
        position = box.localToGlobal(Offset.zero);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeTypeContainer = size.height / 10;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: TranasactionTypeInstance.instance()
              .getModal(modal.transactionTypeRef!.id)
              ?.color,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios)),
          title: Text("Detail Transaction"),
          actions: isEditable
              ? [
                  IconButton(
                      onPressed: () async {
                        bool? isRemove;
                        await showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Remove this transaction",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(25.0),
                                        child: Text(
                                          "Are you sure do you wanna remove this transaction?",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: largestButton(
                                                background: Colors.grey,
                                                text: "No",
                                                onPressed: () =>
                                                    Navigator.pop(context)),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: largestButton(
                                                text: "Yes",
                                                onPressed: () {
                                                  isRemove = true;
                                                  Navigator.pop(context);
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                        isRemove != null && isRemove == true
                            ? await showDialog(
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
                                            "Transaction has been completely removed")
                                      ],
                                    ),
                                  ),
                                ),
                                context: context,
                              )
                            : null;
                      },
                      icon: Icon(Icons.delete_forever_rounded))
                ]
              : null,
          centerTitle: true,
        ),
        body: Stack(children: [
          Column(
            children: [
              Container(
                key: keyAppBar,
                width: size.width,
                padding: EdgeInsets.only(bottom: 50.0),
                decoration: BoxDecoration(
                    color: TranasactionTypeInstance.instance()
                        .getModal(modal.transactionTypeRef!.id)
                        ?.color,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        modal.getMoney(UserInstance.instance()
                            .getCurrency()
                            .currencyCode!),
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${modal.purpose}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${modal.getDateTransaction} ${modal.getTimeTransaction}",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: sizeTypeContainer / 2 + 10.0, left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      10,
                      (index) => Container(
                            height: 4.0,
                            width: size.width / 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                color: Colors.white),
                          )),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  physics: BouncingScrollPhysics(),
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "${modal.description}",
                        maxLines: 5,
                        style: TextStyle(fontSize: 18),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text("Attachment",
                          style: TextStyle(color: Colors.white70)),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: size.height / 3,
                      child: modal.attachments != null
                          ? ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: modal.attachments!
                                  .map((e) => FutureBuilder<Uint8List?>(
                                      future:
                                          ActionFirebaseStorage.downloadFile(e),
                                      initialData: null,
                                      builder: (context, snapshot) =>
                                          snapshot.hasData
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.memory(
                                                    snapshot.data!,
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.all(
                                                      size.height * 0.1),
                                                  width: size.height / 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                )))
                                  .toList(),
                            )
                          : null,
                    ),
                    if (modal.transactionRef != null) Text("data"),
                  ],
                ),
              ),
              if (isEditable)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(10.0),
                      child: largestButton(
                          text: "Edit",
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context,
                                RouteApplication.getRoute(
                                    ERoute.addEditTransaction),
                                arguments: modal);
                            setState(() {});
                          })),
                )
            ],
          ),
          Positioned(
            top: sizeAppBar.height - position.dy / 2,
            left: position.dx,
            height: sizeTypeContainer,
            width: sizeAppBar.width,
            child: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(left: 25.0, right: 25.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Type", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                          TranasactionTypeInstance.instance()
                              .getModal(modal.transactionTypeRef!.id)
                              .toString(),
                          style: TextStyle(color: Colors.black))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Category", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                          CategoryInstance.instance()
                              .getModal(modal.categoryTypeRef!.id)
                              .toString(),
                          style: TextStyle(color: Colors.black))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Account", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                          "${AccountTypeInstance.instance().getModal(modal.accountRef!.id)?.name}",
                          style: TextStyle(color: Colors.black))
                    ],
                  )
                ],
              ),
            ),
          )
        ]));
  }
}
