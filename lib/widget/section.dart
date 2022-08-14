import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class Section extends MultiSliver {
  Section(
      {Key? key,
      String? title,
      Color headerColor = Colors.white,
      Color titleColor = Colors.black,
      String? titleButton,
      double? height,
      void Function()? onPressed,
      required Widget content})
      : super(
          key: key,
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
                child: Container(
              color: headerColor,
              height: height ?? 50,
              alignment: Alignment.centerLeft,
              child: title != null
                  ? (titleButton == null
                      ? Text(
                          title,
                          style: TextStyle(fontSize: 16, color: titleColor),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title,
                                style:
                                    TextStyle(fontSize: 16, color: titleColor)),
                            TextButton(
                                onPressed: onPressed, child: Text(titleButton))
                          ],
                        ))
                  : null,
            )),
            content
          ],
        );
}
