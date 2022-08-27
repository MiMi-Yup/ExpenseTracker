import 'dart:developer';

import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/email_auth.dart';
import 'package:expense_tracker/services/firebase/google_auth.dart';
import 'package:expense_tracker/widgets/check_box.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:expense_tracker/widgets/sign_in_by.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final modal = ModalUser(userName: null, email: null, password: null);
  bool acceptTerm = false;

  String? errorEmail;
  String? errorPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        leading: IconButton(
            onPressed: () => RouteApplication.navigatorKey.currentState
                ?.popUntil(ModalRoute.withName(
                    RouteApplication.getRoute(ERoute.introduction))),
            icon: Icon(Icons.arrow_back_ios_new)),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditText(
                  onChanged: (userName) => modal.userName = userName,
                  labelText: "Tên người dùng",
                  hintText: "User name",
                  enableRegex: true,
                  type: ETypeEditText.normal),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditText(
                  onChanged: (email) => modal.email = email,
                  labelText: "Email",
                  hintText: "Email",
                  errorText: errorEmail,
                  enableRegex: true,
                  type: ETypeEditText.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditText(
                  onChanged: (password) => modal.password = password,
                  labelText: "Mật khẩu",
                  hintText: "Password",
                  errorText: errorPassword,
                  enableRegex: true,
                  type: ETypeEditText.password),
            ),
            checkBox(
                initStateChecked: acceptTerm,
                onChanged: (value) {
                  setState(() => acceptTerm = value ?? false);
                },
                text: "Bạn chấp nhận với những ",
                action: GestureDetector(
                    onTap: () => Navigator.pushNamed(context,
                        RouteApplication.getRoute(ERoute.termOfCondition)),
                    child: Text("Điều khoản",
                        style: TextStyle(color: MyColor.purple(alpha: 255))))),
            Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16.0),
                child: largestButton(
                    text: "Sign Up",
                    background: acceptTerm ? MyColor.purple() : Colors.grey,
                    onPressed: () async {
                      if (modal.validation) {
                        if (acceptTerm) {
                          UserCredential? user =
                              await EmailAuth.createUserWithPassword(
                                      email: modal.email!,
                                      password: modal.password!)
                                  .catchError((err) {
                            errorPassword = null;
                            errorEmail = null;
                            if (err is FirebaseAuthException) {
                              switch ((err as FirebaseAuthException).code) {
                                case 'weak-password':
                                  setState(() => errorPassword =
                                      "Weak password. Please try password stronger!");
                                  break;
                                case 'email-already-in-use':
                                  setState(() => errorEmail =
                                      "User exist! Swtich to login page.");
                                  break;
                                case 'invalid-email':
                                  setState(
                                      () => errorEmail = "Wrong email format");
                                  break;
                                default:
                                  print((err as FirebaseAuthException).code);
                              }
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please accept term of condition"),
                            action: SnackBarAction(
                                label: "Accept",
                                onPressed: () =>
                                    setState(() => acceptTerm = true)),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please fill field")));
                      }
                    })),
            Align(
                alignment: Alignment.center,
                child: Text("Or with",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20))),
            SignInByButton(
                child: Text(
                  "Sign in with Google",
                  style: TextStyle(fontSize: 15),
                ),
                iconAsset: IconAsset.logoGoogle,
                onPressed: () async {
                  UserCredential? user = await GoogleAuth.signInWithGoogle();
                }).builder(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouteApplication.getRoute(ERoute.login)),
                      child: Text("Login",
                          style: TextStyle(color: MyColor.purple(alpha: 255))))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
