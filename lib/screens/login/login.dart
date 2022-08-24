import 'dart:developer';

import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            editText(
                onChanged: (p0) => log(p0),
                labelText: "Email",
                hintText: "Email",
                isPassword: false),
            editText(
                onChanged: (p0) => log(p0),
                labelText: "Mật khẩu",
                hintText: "Password",
                isPassword: true),
            Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16.0),
                child: largestButton(
                    text: "Login",
                    onPressed: () => Navigator.pushNamed(
                        context, RouteApplication.getRoute(ERoute.pin),
                        arguments: true),
                    background: MyColor.purple(alpha: 255))),
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
                    "Don;t have an account yet? ",
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
