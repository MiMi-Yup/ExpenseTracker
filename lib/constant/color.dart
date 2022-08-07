import 'dart:ui';

class MyColor {
  static Color purple({int? alpha}) =>
      Color.fromARGB(alpha ?? 255, 127, 61, 255);
  static Color mainBackgroundColor = const Color.fromARGB(255, 48, 48, 48);
  static Color purpleTranparent = const Color.fromARGB(255, 238, 229, 255);
}
