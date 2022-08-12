import 'package:expense_tracker/page/add_edit_transaction/add_edit_transaction.dart';
import 'package:expense_tracker/page/first_setup/add_new_account.dart';
import 'package:expense_tracker/page/first_setup/code_auth.dart';
import 'package:expense_tracker/page/first_setup/introduction_setup.dart';
import 'package:expense_tracker/page/first_setup/success.dart';
import 'package:expense_tracker/page/home/nav.dart';
import 'package:expense_tracker/page/introduction.dart';
import 'package:expense_tracker/page/notification.dart';
import 'package:expense_tracker/page/report/overview_report.dart';
import 'package:expense_tracker/page/signup/signup.dart';
import 'package:expense_tracker/page/signup/verify.dart';
import 'package:expense_tracker/page/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: OverviewReport(),
    );
  }
}
