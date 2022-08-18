import 'package:expense_tracker/constant/route.dart';
import 'package:expense_tracker/page/add_edit_transaction/add_edit_transaction.dart';
import 'package:expense_tracker/page/budget/add_edit_budget.dart';
import 'package:expense_tracker/page/budget/budget_page.dart';
import 'package:expense_tracker/page/detail_transaction/detail_transaction.dart';
import 'package:expense_tracker/page/account/add_new_account.dart';
import 'package:expense_tracker/page/first_setup/code_auth.dart';
import 'package:expense_tracker/page/first_setup/introduction_setup.dart';
import 'package:expense_tracker/page/first_setup/success.dart';
import 'package:expense_tracker/page/home/home_page.dart';
import 'package:expense_tracker/page/home/nav.dart';
import 'package:expense_tracker/page/introduction.dart';
import 'package:expense_tracker/page/notification.dart';
import 'package:expense_tracker/page/profile/account_page.dart';
import 'package:expense_tracker/page/report/detail_report.dart';
import 'package:expense_tracker/page/report/overview_report.dart';
import 'package:expense_tracker/page/setting/setting_preference.dart';
import 'package:expense_tracker/page/signup/signup.dart';
import 'package:expense_tracker/page/signup/verify.dart';
import 'package:expense_tracker/page/welcome_page.dart';
import 'package:expense_tracker/route.dart';
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
      routes: RouteApplication.routes,
      initialRoute: RouteApplication.getRoute(ERoute.welcome),
    );
  }
}
