import 'package:flutter/material.dart';

class SignInByButton {
  void Function()? onPressed;
  Text child;
  String? iconAsset;
  SignInByButton({this.onPressed, this.iconAsset, required this.child});
  Widget builder() {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconAsset != null) Image.asset(iconAsset!),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: child,
                  )
                ])));
  }
}
