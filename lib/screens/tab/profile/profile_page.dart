import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/asset/category.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/instances/data.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/screens/tab/profile/account_page.dart';
import 'package:expense_tracker/screens/tab/profile/export_page.dart';
import 'package:expense_tracker/screens/tab/profile/setting_preference.dart';
import 'package:expense_tracker/services/firebase/auth/google_auth.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final _actions = <String, Object?>{
    "Wallet": const AccountPage(),
    "Settings": const SettingPreference(),
    "Export": const ExportPage(),
    "Logout": null
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(CategoryAsset.moneyBag),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Iriana Saliha",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
              IconButton(
                  onPressed: () async {
                    // FirebaseFirestore.instance
                    //     .collection('user/user01/account').doc('account01').set({'typeAccountRef':FirebaseFirestore.instance.doc('typeAccount/01')});
                    FirebaseFirestore.instance
                        .doc('user/user01/account/account01')
                        .get()
                        .then((value) => value
                            .data()!['typeAccountRef']
                            .get()
                            .then((value) => print(value.data())));
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16.0)),
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
                                                  topLeft:
                                                      Radius.circular(10.0),
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
                                                              Navigator.pop(
                                                                  context),
                                                          background:
                                                              Colors.grey)),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Expanded(
                                                      child: largestButton(
                                                          text: "Yes",
                                                          onPressed: () =>
                                                              GoogleAuth
                                                                  .signOut(),
                                                          background:
                                                              MyColor.purple()))
                                                ],
                                              )
                                            ],
                                          ),
                                        ));
                              }
                            : (e.value is Widget
                                ? () => RouteApplication
                                        .navigatorKey.currentState
                                        ?.push(MaterialPageRoute<void>(
                                      builder: (context) => e.value as Widget,
                                    ))
                                : null),
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
      ),
    );
  }
}
