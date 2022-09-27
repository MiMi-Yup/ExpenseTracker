import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/screens/account/detail_account.dart';
import 'package:expense_tracker/screens/add_types/add_edit_account_types.dart';
import 'package:expense_tracker/screens/add_types/add_edit_category_types.dart';
import 'package:expense_tracker/screens/add_types/edit_transaction_types.dart';
import 'package:expense_tracker/screens/budget/add_edit_budget.dart';
import 'package:expense_tracker/screens/first_setup/code_auth.dart';
import 'package:expense_tracker/screens/first_setup/introduction_setup.dart';
import 'package:expense_tracker/screens/account/add_new_account.dart';
import 'package:expense_tracker/screens/introduction.dart';
import 'package:expense_tracker/screens/login/forgot_password.dart';
import 'package:expense_tracker/screens/login/login.dart';
import 'package:expense_tracker/screens/notification.dart';
import 'package:expense_tracker/screens/signup/signup.dart';
import 'package:expense_tracker/screens/tab/budget/detail_budget.dart';
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
    getRoute(ERoute.welcome): (context) => const WelcomePage(),
    getRoute(ERoute.introduction): (context) => const Introduction(),
    getRoute(ERoute.login): (context) => const Login(),
    getRoute(ERoute.signUp): (context) => const SignUp(),
    getRoute(ERoute.authGoogle): (context) => /*const*/ Container(),
    getRoute(ERoute.forgotPassword): (context) => const ForgotPassword(),
    getRoute(ERoute.pin): (context) => const CodeAuth(),
    getRoute(ERoute.setDefault): (context) => const AddNewAccount(),
    getRoute(ERoute.introductionSetupAccount): (context) => IntroductionSetup(),
    getRoute(ERoute.main): (context) => const Navigation(),
    getRoute(ERoute.notification): (context) => const NotificationPage(),
    getRoute(ERoute.overviewReport): (context) => const OverviewReport(),
    getRoute(ERoute.detailReport): (context) => const DetailReport(),
    getRoute(ERoute.addEditBudget): (context) => const AddEditBudget(),
    getRoute(ERoute.overviewAccount): (context) => const AccountPage(),
    getRoute(ERoute.detailAccount): (context) => const DetailAccount(),
    getRoute(ERoute.export): (context) => const ExportPage(),
    getRoute(ERoute.setting): (context) => const SettingPreference(),
    getRoute(ERoute.addEditAccount): (context) => const AddNewAccount(),
    getRoute(ERoute.addEditTransaction): (context) =>
        const AddEditTransaction(),
    getRoute(ERoute.detailTransaction): (context) => const DetailTransaction(),
    getRoute(ERoute.termOfCondition): (context) => /*const*/ Container(),
    getRoute(ERoute.addEditAccountType): (context) =>
        const AddEditAccountTypes(),
    getRoute(ERoute.addEditCategoryType): (context) =>
        const AddEditCategoryTypes(),
    getRoute(ERoute.editTransactionType): (context) =>
        const EditTransactionTypes(),
    getRoute(ERoute.detailBudget): (context) => const DetailBudget(),
  };

  static String getRoute(ERoute route) => "/${route.name}";

  static final navigatorKey = GlobalKey<NavigatorState>();
}
