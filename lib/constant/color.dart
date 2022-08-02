import 'dart:ui';

class MyColor {
  static Color purple({int? alpha}) =>
      Color.fromARGB(alpha ?? 255, 127, 61, 255);
  static Color mainBackgroundColor = const Color.fromARGB(255, 48, 48, 48);
}
