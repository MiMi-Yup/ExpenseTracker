import 'dart:developer';

import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/email_auth.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:expense_tracker/widgets/sign_in_by.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final modal = ModalUser(userName: null, email: null, password: null);

  String? errorEmail;
  String? errorPassword;

  bool enableLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        leading: IconButton(
            onPressed: () => Navigator.popUntil(
                context,
                ModalRoute.withName(
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
                  onChanged: (value) {
                    modal.email = value;
                    setState(() => enableLogin = modal.validation);
                  },
                  labelText: "Email",
                  hintText: "Email",
                  errorText: errorEmail,
                  type: ETypeEditText.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditText(
                  onChanged: (value) {
                    modal.password = value;
                    setState(() => enableLogin = modal.validation);
                  },
                  labelText: "Mật khẩu",
                  hintText: "Password",
                  errorText: errorPassword,
                  type: ETypeEditText.password),
            ),
            Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16.0),
                child: largestButton(
                    text: "Login",
                    background: enableLogin ? MyColor.purple() : Colors.grey,
                    onPressed: () async {
                      if (modal.validation) {
                        UserCredential? user =
                            await EmailAuth.signInWithPassword(
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
                              case 'wrong-password':
                                setState(
                                    () => errorPassword = "Wrong password");
                                break;
                              case 'user-not-found':
                                setState(() => errorEmail = "User not exist");
                                break;
                              default:
                                print((err as FirebaseAuthException).code);
                            }
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please fill field")));
                      }
                    })),
            SignInByButton(
                    child: Text(
                      "Sign in with Google",
                      style: TextStyle(fontSize: 15),
                    ),
                    iconAsset: IconAsset.logoGoogle,
                    onPressed: () => Navigator.pushNamed(
                        context, RouteApplication.getRoute(ERoute.authGoogle)))
                .builder(),
            Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context,
                      RouteApplication.getRoute(ERoute.forgotPassword)),
                  child: Text("Forgot password?",
                      style: TextStyle(color: MyColor.purple(alpha: 255))),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account yet? ",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouteApplication.getRoute(ERoute.signUp)),
                      child: Text("Sign Up",
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
