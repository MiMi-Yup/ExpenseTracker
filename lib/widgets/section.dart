import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'dart:math' as math;

class Section {
  Key? key;
  String? title;
  Color headerColor;
  Color titleColor;
  double? height;
  Widget content;
  bool headerPressable;
  Widget? action;
  void Function()? onPressed;
  AnimationController? controller;

  Section(
      {this.key,
      this.title,
      this.headerColor = Colors.white,
      this.titleColor = Colors.black,
      required this.content,
      this.height,
      this.headerPressable = false,
      this.onPressed,
      this.action,
      this.controller});

  MultiSliver builder() {
    final header = Text(
      title ?? "",
      style: TextStyle(fontSize: 16, color: titleColor),
    );

    final _action = action == null
        ? controller == null
            ? null
            : AnimatedBuilder(
                animation: controller!,
                builder: (context, child) => Transform(
                      transform:
                          Matrix4.rotationZ(controller!.value * -math.pi),
                      alignment: FractionalOffset.center,
                      child: Icon(Icons.keyboard_arrow_up),
                    ))
        : TextButton(onPressed: onPressed, child: action!);

    final structure = Container(
      color: headerColor,
      height: height ?? 50,
      alignment: Alignment.centerLeft,
      child: title == null
          ? null
          : (action == null
              ? controller != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [header, _action!],
                    )
                  : header
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [header, _action!],
                )),
    );

    return MultiSliver(key: key, pushPinnedChildren: true, children: [
      SliverPinnedHeader(
          child: headerPressable
              ? GestureDetector(
                  child: structure,
                  onTap: onPressed,
                )
              : structure),
      content,
    ]);
  }
}
