import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

StatefulBuilder countdown(
    {required Duration time, required void Function() finished}) {
  Duration count = time;
  Timer? _timer;
  return StatefulBuilder(builder: (context, setState) {
    _timer ??= Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() => count = Duration(seconds: count.inSeconds - 1));
      if (count.inSeconds == 0) {
        finished();
        timer.cancel();
      }
    });
    return Text(
      "${count.inMinutes}:${count.inSeconds - count.inMinutes * 60}",
      style: TextStyle(fontSize: 20, color: Colors.amber),
    );
  });
}
