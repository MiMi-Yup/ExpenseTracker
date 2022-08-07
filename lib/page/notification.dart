import 'package:expense_tracker/constant/color.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.done_all),
                            Text("Mark all read")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever),
                            Text("Remove all")
                          ],
                        ),
                      ),
                    ],
                offset: Offset(0, 50),
                onSelected: null),
          ),
        ],
        leading: IconButton(
          onPressed: null,
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text("Notification"),
        elevation: 0.0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
    );
  }
}
