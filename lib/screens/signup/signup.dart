import 'dart:developer';

import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/check_box.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            editText(
                onChanged: (p0) => log(p0),
                labelText: "Tên người dùng",
                hintText: "User name",
                isPassword: false),
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
            checkBox(
                initStateChecked: false,
                onChanged: (value) => log(value.toString()),
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
                    onPressed: () => Navigator.pushNamed(
                        context, RouteApplication.getRoute(ERoute.verify)),
                    background: MyColor.purple(alpha: 255))),
            Align(
                alignment: Alignment.center,
                child: Text("Or with",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20))),
            Container(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteApplication.getRoute(ERoute.authGoogle)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(IconAsset.logoGoogle),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Sign Up with Google",
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ]))),
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
