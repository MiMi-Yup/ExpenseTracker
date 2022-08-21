import 'package:flutter/material.dart';

TextButton largestButton(
        {Color textColor = Colors.white,
        Color background = Colors.purple,
        required String text,
        TextStyle? style,
        required void Function() onPressed}) =>
    TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            backgroundColor: MaterialStateProperty.all(background)),
        child: Text(text,
            style: style ?? TextStyle(color: textColor, fontSize: 25)));
