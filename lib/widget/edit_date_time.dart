import 'package:flutter/material.dart';

Row editDateTime(
        {required IconData? icon,
        required String value,
        String? actionButton,
        required void Function()? onPressed}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icon ?? Icons.question_mark_rounded),
            ),
            Text(value),
          ],
        ),
        TextButton(onPressed: onPressed, child: Text(actionButton ?? "Change"))
      ],
    );
