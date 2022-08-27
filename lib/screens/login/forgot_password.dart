import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/editText.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: null,
          ),
          title: Text("Forgot Password"),
          centerTitle: true,
          backgroundColor: MyColor.mainBackgroundColor,
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't worry.\nEnter your email and we'll send you a link to reset your password.",
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                softWrap: false,
                style: TextStyle(
                    fontSize: 30, letterSpacing: 2.5, wordSpacing: 2.5),
              ),
              SizedBox(
                height: 100,
              ),
              EditText(
                  onChanged: (value) => null,
                  hintText: "Email",
                  labelText: "Email"),
              Container(
                padding: EdgeInsets.all(10.0),
                width: double.maxFinite,
                child: largestButton(
                    text: "Continue",
                    onPressed: () {
                      showDialog(
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
                                Text("Email reset password has been sent")
                              ],
                            ),
                          ),
                        ),
                        context: context,
                      );

                      Future.delayed(
                          const Duration(seconds: 1),
                          () => Navigator.popUntil(
                              context,
                              ModalRoute.withName(
                                  RouteApplication.getRoute(ERoute.login))));
                    }),
              )
            ],
          ),
        ));
  }
}
