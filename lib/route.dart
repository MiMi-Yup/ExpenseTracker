import 'package:expense_tracker/constant/enum/enum_route.dart';
import 'package:expense_tracker/page/account/add_new_account.dart';
import 'package:expense_tracker/page/add_edit_transaction/add_edit_transaction.dart';
import 'package:expense_tracker/page/budget/add_edit_budget.dart';
import 'package:expense_tracker/page/detail_transaction/detail_transaction.dart';
import 'package:expense_tracker/page/export/export_page.dart';
import 'package:expense_tracker/page/first_setup/code_auth.dart';
import 'package:expense_tracker/page/first_setup/introduction_setup.dart';
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
import 'package:flutter/material.dart';

class RouteApplication {
  static final Map<String, Widget Function(BuildContext)> routes =
      <String, Widget Function(BuildContext)>{
    getRoute(ERoute.welcome): (context) => WelcomePage(),
    getRoute(ERoute.introduction): (context) => Introduction(),
    getRoute(ERoute.login): (context) => Container(),
    getRoute(ERoute.signUp): (context) => SignUp(),
    getRoute(ERoute.verify): (context) => OTPVerify(),
    getRoute(ERoute.authGoogle): (context) => Container(),
    getRoute(ERoute.emailRecovery): (context) => Container(),
    getRoute(ERoute.pin): (context) => CodeAuth(),
    getRoute(ERoute.introductionSetupAccount): (context) => IntroductionSetup(),
    getRoute(ERoute.main): (context) => Navigation(),
    getRoute(ERoute.notification): (context) => NotificationPage(),
    getRoute(ERoute.overviewReport): (context) => OverviewReport(),
    getRoute(ERoute.detailReport): (context) => DetailReport(),
    getRoute(ERoute.addEditBudget): (context) => AddEditBudget(),
    getRoute(ERoute.overviewAccount): (context) => AccountPage(),
    getRoute(ERoute.detailAccount): (context) => Container(),
    getRoute(ERoute.export): (context) => ExportPage(),
    getRoute(ERoute.setting): (context) => SettingPreference(),
    getRoute(ERoute.addEditAccount): (context) => AddNewAccount(),
    getRoute(ERoute.addEditTransaction): (context) => AddEditTransaction(),
    getRoute(ERoute.detailTransaction): (context) => DetailTransaction(),
    getRoute(ERoute.termOfCondition): (context) => Container()
  };

  static String getRoute(ERoute route) => "/${route.name}";
}
