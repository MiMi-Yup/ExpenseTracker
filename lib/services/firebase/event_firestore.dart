import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/init.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/budget.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/test/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum StatusIsolateThread {
  transactionChanged,
  budgetChanged,
  notificationTap,
  none
}

class EventFirestore {
  static EventFirestore? _instance;
  final NotificationService notificationService = NotificationService();
  static StreamSubscription<QuerySnapshot>? _streamSubscriptionLog;
  static StreamSubscription<QuerySnapshot>? _streamSubscriptionBudget;
  static StreamSubscription<User?>? _streamSubscriptionUser;

  EventFirestore._() {
    _initApplication();
  }

  factory EventFirestore.instance() {
    if (_instance != null) {
      _streamSubscriptionBudget?.cancel();
      _streamSubscriptionLog?.cancel();
      _streamSubscriptionUser?.cancel();
      _instance = null;
    }

    _instance = EventFirestore._();
    return _instance!;
  }

  void budgetCollectionChanged(
      List<DocumentChange<ModalBudget>> docChanges) async {
    BudgetUtilities serviceBudget = BudgetUtilities();
    for (DocumentChange<ModalBudget> doc in docChanges) {
      ModalBudget? modal = doc.doc.data();
      if (modal != null) {
        serviceBudget.getTransactionsInBudget(modal).then((list) {
          double total = 0.0;
          for (var element in list) {
            total += element.money ?? 0.0;
          }
          if (modal.isAlert(total) || modal.isExceedLimit(total)) {
            log("budget notification", name: "aaaaa");
          }
        });
      }
    }
  }

  void transactionCollectionChanged(
      List<DocumentChange<ModalTransactionLog>> docChanges) async {
    TransactionFirestore serviceTransaction = TransactionFirestore();
    TransactionUtilities serviceLog = TransactionUtilities();
    for (DocumentChange<ModalTransactionLog> doc in docChanges) {}
  }

  void budgetChangeListener() async {
    CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();
    BudgetFirestore serviceBudget = BudgetFirestore();

    _streamSubscriptionLog = serviceLog.stream.listen((event) async {
      if (event.docChanges.isNotEmpty) {
        //await FlutterIsolate.spawn(isolateThread, port.sendPort);
        transactionCollectionChanged(event.docChanges);
      }
    }, onError: (error) {});

    _streamSubscriptionBudget = serviceBudget.stream.listen((event) async {
      if (event.docChanges.isNotEmpty) {
        if (event.docChanges.firstWhereOrNull((element) =>
                element.type == DocumentChangeType.added ||
                element.type == DocumentChangeType.modified) !=
            null) {
          //cal
          //await FlutterIsolate.spawn(isolateThread, port.sendPort);
          budgetCollectionChanged(event.docChanges);
        } else {
          //remove all notification about budget
        }
      }
    }, onError: (error) {});
  }

  Future<void> _initApplication() async {
    notificationService.initializePlatformNotifications();

    await Future.delayed(const Duration(seconds: 2), () {
      UserInstance.instance(renew: true);
      CategoryInstance.instance(renew: true);
      TranasactionTypeInstance.instance(renew: true);
      AccountTypeInstance.instance(renew: true);
    });

    _streamSubscriptionUser =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        RouteApplication.navigatorKey.currentState?.pushReplacementNamed(
            RouteApplication.getRoute(ERoute.introduction));
      } else {
        if (!user.emailVerified) {
          user.sendEmailVerification();
          if (RouteApplication.navigatorKey.currentContext != null) {
            await showDialog(
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        IconAsset.success,
                        scale: 2,
                      ),
                      SizedBox(height: 16.0),
                      Text("Please check your email to verify your account.")
                    ],
                  ),
                ),
              ),
              context: RouteApplication.navigatorKey.currentContext!,
            );
          }
        }

        budgetChangeListener();

        UserFirestore userFirestore = UserFirestore();

        bool checkUserExists = await userFirestore.checkUserExists();
        if (!checkUserExists) {
          InitializationFirestore().copyDefaultToUser(user.uid);
        }

        bool initUser = true;
        List<ModalUser>? fieldUser = await userFirestore.read();
        if (fieldUser != null &&
            fieldUser.isNotEmpty &&
            fieldUser.first.passcode != null) {
          initUser = false;
        }

        RouteApplication.navigatorKey.currentState
            ?.popUntil((route) => route.isFirst);
        RouteApplication.navigatorKey.currentState?.pushReplacementNamed(
            RouteApplication.getRoute(ERoute.pin),
            arguments: initUser);
      }
    }, onError: (error) {});
  }
}
