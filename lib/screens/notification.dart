import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_notification.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/notification.dart';
import 'package:expense_tracker/widgets/component/budget_component.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationFirestore serviceNotification = NotificationFirestore();
  final BudgetFirestore serviceBudget = BudgetFirestore();

  Stream<QuerySnapshot<ModalNotification>>? _stream;

  @override
  void initState() {
    super.initState();
    _stream = serviceNotification.stream;
  }

  @override
  void dispose() {
    _stream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: PopupMenuButton<int>(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.done_all),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Mark all read")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Remove all")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Remove all")
                          ],
                        ),
                      )
                    ],
                offset: Offset(0, 50),
                onSelected: (indexSelected) async {
                  switch (indexSelected) {
                    case 0:
                      await serviceNotification.setReadAll();
                      break;
                    case 1:
                      await serviceNotification.deleteAll();
                      break;
                    case 2:
                      await serviceNotification.insert(ModalNotification(
                          id: null,
                          timeCreate: Timestamp.now(),
                          isRead: false,
                          title: 'title',
                          reasonNotification: 'reasonNotification',
                          budgetRef: null));
                      break;
                    default:
                  }
                }),
          ),
        ],
        leading: IconButton(
          onPressed: () => RouteApplication.navigatorKey.currentState?.pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text("Notification"),
        elevation: 0.0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: StreamBuilder<QuerySnapshot<ModalNotification>>(
          stream: _stream,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Iterable<ModalNotification> data =
                  snapshot.data!.docs.map((e) => e.data());

              return ListView(
                  children: data
                      .map((modal) => GestureDetector(
                            onTap: () async {
                              serviceNotification.setRead(modal);
                              showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0))),
                                  builder: (context) => Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: FutureBuilder<ModalBudget?>(
                                          future: serviceBudget.getModalFromRef(
                                              modal.budgetRef!),
                                          builder: (context, snapshot) =>
                                              snapshot.hasData
                                                  ? BudgetComponent(
                                                      modal: snapshot.data!,
                                                      nowMoney: 550.0)
                                                  : LinearProgressIndicator(),
                                        ),
                                      ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: modal.isRead == true
                                      ? Colors.deepPurple
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${modal.title}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            '${modal.reasonNotification}',
                                            style:
                                                TextStyle(color: Colors.grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Column(
                                      children: [
                                        Text('${modal.getTImeNotification}',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text('${modal.getDateTransaction}',
                                            style:
                                                TextStyle(color: Colors.grey))
                                      ],
                                    )
                                  ]),
                            ),
                          ))
                      .toList());
            } else
              return Center(child: Text('Wait for loading'));
          }),
    );
  }
}
