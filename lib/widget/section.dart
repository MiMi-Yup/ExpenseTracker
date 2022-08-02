import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class Section extends MultiSliver {
  Section(
      {Key? key,
      String? title,
      Color headerColor = Colors.white,
      Color titleColor = Colors.black,
      required Widget content})
      : super(
          key: key,
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
                child: ColoredBox(
                    color: headerColor,
                    child: ListTile(
                      textColor: titleColor,
                      title: title != null ? Text(title) : null,
                    ))),
            content
          ],
        );
}
