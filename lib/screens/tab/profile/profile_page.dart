import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/auth/google_auth.dart';
import 'package:expense_tracker/services/firebase/event_firestore.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final _actions = <String, ERoute?>{
    "Wallet": ERoute.overviewAccount,
    "Settings": ERoute.setting,
    "Export": ERoute.export,
    "Logout": null
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppBar(
            backgroundColor: MyColor.mainBackgroundColor,
            elevation: 0.0,
            leading: UserInstance.instance().modal != null &&
                    UserInstance.instance().modal?.photoURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                        UserInstance.instance().modal!.photoURL!,
                        scale: 1.0))
                : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${UserInstance.instance().modal?.email}',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  '${UserInstance.instance().modal?.displayName}',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            actions: [
              IconButton(onPressed: () async {}, icon: Icon(Icons.edit))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(16.0)),
          child: Column(
            children: _actions.entries
                .map((e) => GestureDetector(
                      onTap: e.value == null
                          ? () async {
                              await showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Logout?",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            Padding(
                                              padding: EdgeInsets.all(25.0),
                                              child: Text(
                                                "Are you sure do you wanna logout?",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: largestButton(
                                                        text: "No",
                                                        onPressed: () =>
                                                            RouteApplication
                                                                .navigatorKey
                                                                .currentState
                                                              ?..pop(),
                                                        background:
                                                            Colors.grey)),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                    child: largestButton(
                                                        text: "Yes",
                                                        onPressed: () async {
                                                          EventFirestore
                                                              .instance();
                                                          await GoogleAuth
                                                              .signOut();
                                                        },
                                                        background:
                                                            MyColor.purple()))
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                            }
                          : () => RouteApplication.navigatorKey.currentState
                              ?.pushNamed(RouteApplication.getRoute(e.value!)),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: MyColor.purpleTranparent,
                                  borderRadius: BorderRadius.circular(8.0)),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.wallet,
                                color: MyColor.purple(),
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(e.key)
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
