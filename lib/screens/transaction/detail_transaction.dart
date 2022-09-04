import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class DetailTransaction extends StatefulWidget {
  DetailTransaction({Key? key}) : super(key: key);

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  late List<Object>? arguments =
      ModalRoute.of(context)?.settings.arguments as List<Object>?;
  late ModalTransaction? modal = arguments?[0] as ModalTransaction?;
  late bool isEditable = (arguments?[1] as bool?) ?? false;

  final heightAnchor = 75.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      Container(
        width: double.maxFinite,
        height: size.height / 3,
        decoration: BoxDecoration(
            // color: MyColor.colorTransaction[modal?.typeTransaction] ??
            //     Colors.white70,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(25.0),
                                            child: Text(
                                              "Are you sure do you wanna remove this transaction?",
                                              style:
                                                  TextStyle(color: Colors.grey),
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
            Text(
              "${modal?.getMoney}",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              "${modal?.purpose}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "${modal?.getDateTransaction} ${modal?.getTimeTransaction}",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            )
          ],
        ),
      ),
      Container(
        height: heightAnchor,
        margin: EdgeInsets.only(
            top: size.height / 3 - heightAnchor / 2, left: 25.0, right: 25.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), color: Colors.white),
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
                // Text(
                //     "${modal?.typeTransaction?.name[0].toUpperCase()}${modal?.typeTransaction?.name.substring(1).toLowerCase()}",
                //     style: TextStyle(color: Colors.black))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Category", style: TextStyle(color: Colors.grey)),
                SizedBox(
                  height: 20.0,
                ),
                // Text(
                //     "${modal?.category?.name[0].toUpperCase()}${modal?.category?.name.substring(1).toLowerCase()}",
                //     style: TextStyle(color: Colors.black))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Account", style: TextStyle(color: Colors.grey)),
                SizedBox(
                  height: 20.0,
                ),
                // Text("${modal?.account}", style: TextStyle(color: Colors.black))
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            top: size.height / 3 + heightAnchor / 2, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
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
            Text(
              "Description",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "${modal?.description}",
              maxLines: 5,
              style: TextStyle(fontSize: 18),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Text("Attachment", style: TextStyle(color: Colors.white70)),
            Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              child: modal?.attachments != null
                  ? Image.asset(IconAsset.success, fit: BoxFit.fill)
                  : null,
            ),
            if (isEditable)
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: double.maxFinite,
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
                ),
              )
          ],
        ),
      )
    ]));
  }
}
