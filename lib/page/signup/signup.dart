import 'dart:developer';
import 'dart:ui';

import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/check_box.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:expense_tracker/widget/text_field.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        leading: IconButton(
            onPressed: () => null, icon: Icon(Icons.arrow_back_ios_new)),
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
                    onTap: () => log("term of"),
                    child: Text("Điều khoản",
                        style: TextStyle(color: MyColor.purple(alpha: 255))))),
            Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16.0),
                child: largestButton(
                    text: "Sign Up",
                    onPressed: () => log("sign up"),
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
                    onTap: () => log("login by google"),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("asset/image/logo_google.png"),
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
                      onTap: () => log("have an account"),
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
