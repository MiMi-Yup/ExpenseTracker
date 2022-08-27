import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/screens/account/add_new_account.dart';
import 'package:expense_tracker/screens/budget/add_edit_budget.dart';
import 'package:expense_tracker/screens/first_setup/code_auth.dart';
import 'package:expense_tracker/screens/first_setup/introduction_setup.dart';
import 'package:expense_tracker/screens/introduction.dart';
import 'package:expense_tracker/screens/login/forgot_password.dart';
import 'package:expense_tracker/screens/login/login.dart';
import 'package:expense_tracker/screens/notification.dart';
import 'package:expense_tracker/screens/signup/signup.dart';
import 'package:expense_tracker/screens/signup/verify.dart';
import 'package:expense_tracker/screens/tab/nav.dart';
import 'package:expense_tracker/screens/tab/profile/account_page.dart';
import 'package:expense_tracker/screens/tab/profile/export_page.dart';
import 'package:expense_tracker/screens/tab/profile/setting_preference.dart';
import 'package:expense_tracker/screens/tab/transaction/report/detail_report.dart';
import 'package:expense_tracker/screens/tab/transaction/report/overview_report.dart';
import 'package:expense_tracker/screens/transaction/add_edit_transaction.dart';
import 'package:expense_tracker/screens/transaction/detail_transaction.dart';
import 'package:expense_tracker/screens/welcome_page.dart';
import 'package:flutter/material.dart';

class RouteApplication {
  static final Map<String, Widget Function(BuildContext)> routes =
      <String, Widget Function(BuildContext)>{
    getRoute(ERoute.welcome): (context) => WelcomePage(),
    getRoute(ERoute.introduction): (context) => Introduction(),
    getRoute(ERoute.login): (context) => Login(),
    getRoute(ERoute.signUp): (context) => SignUp(),
    getRoute(ERoute.verify): (context) => OTPVerify(),
    getRoute(ERoute.authGoogle): (context) => Container(),
    getRoute(ERoute.forgotPassword): (context) => ForgotPassword(),
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

  static final navigatorKey = GlobalKey<NavigatorState>();
}
