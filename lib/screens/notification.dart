import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/modals/modal_notification.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/notification.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationFirestore service = NotificationFirestore();

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
                            Text("Mark all read")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever),
                            Text("Remove all")
                          ],
                        ),
                      )
                    ],
                offset: Offset(0, 50),
                onSelected: (indexSelected) async {
                  switch (indexSelected) {
                    case 0:
                      await service.setReadAll();
                      break;
                    case 1:
                      await service.deleteAll();
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
          stream: service.stream,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Iterable<ModalNotification> data =
                  snapshot.data!.docs.map((e) => e.data());

              return ListView(
                  children: data
                      .map((modal) => GestureDetector(
                            onTap: null,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
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
