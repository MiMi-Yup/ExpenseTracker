import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/init.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

class EventFirestore {
  static EventFirestore? _instance;

  EventFirestore._() {
    _initApplication();
    //x();
  }

  factory EventFirestore.instance() {
    _instance ??= EventFirestore._();
    return _instance!;
  }

  static call(_) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();
    serviceLog.stream.listen((event) {
      event.docChanges.forEach((element) {
        if (element.type != DocumentChangeType.removed) {
          ModalTransactionLog? x = element.doc.data();
        }
      });
    });
  }

  void x() async {
    final isolate = await FlutterIsolate.spawn(call, {});
  }

  Future<void> _initApplication() async {
    await Future.delayed(const Duration(seconds: 2), () {
      UserInstance.instance();
      CategoryInstance.instance();
      TranasactionTypeInstance.instance();
      AccountTypeInstance.instance();
    });

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

        UserFirestore userFirestore = UserFirestore();

        bool checkUserExists = await userFirestore.checkUserExists();
        if (!checkUserExists) {
          InitializationFirestore().copyDefaultToUser(user.uid);
        }

        bool initUser = true;
        List<ModalUser> fieldUser = await userFirestore.read();
        if (fieldUser.isNotEmpty && fieldUser.first.passcode != null) {
          initUser = false;
        }

        RouteApplication.navigatorKey.currentState
            ?.popUntil((route) => route.isFirst);
        RouteApplication.navigatorKey.currentState?.pushReplacementNamed(
            RouteApplication.getRoute(ERoute.pin),
            arguments: initUser);
      }
    });
  }
}
