import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_currency_type.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/init.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double opacityLevel = 0.0;
  Timer? _timer;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  Future<void> initApplication() async {
    await Future.delayed(const Duration(seconds: 5), () {
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

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(seconds: 2), (timer) => _changeOpacity());
    initApplication();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.redAccent, shape: BoxShape.circle),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: MyColor.purple(alpha: 200)),
            child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: opacityLevel,
                child: Center(
                  child: Text(
                    "montra",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
