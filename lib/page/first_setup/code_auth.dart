import 'package:expense_tracker/widget/input_otp.dart';
import 'package:flutter/material.dart';

class CodeAuth extends StatefulWidget {
  bool initCode;
  CodeAuth({Key? key, required this.initCode}) : super(key: key);

  @override
  State<CodeAuth> createState() => _CodeAuthState();
}

class _CodeAuthState extends State<CodeAuth>
    with SingleTickerProviderStateMixin {
  late bool _confirm;
  String _code = "";
  String _reCode = "";
  late AnimationController controller;
  final Map<String, String?> message = <String, String?>{
    "setup": "Let’s setup your PIN",
    "confirm": "Ok. Re type your PIN again",
    "enter": "Enter your PIN",
    "wrong": "Incorrect PIN, please try again"
  };
  String title = "";

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
    _confirm = !widget.initCode;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _changedTitle({bool wrongPIN = false}) {
    if (wrongPIN) {
      setState(() {
        title = message["wrong"]!;
      });
      controller.forward(from: 0.0);
    } else {
      setState(() {
        title = widget.initCode
            ? (_confirm ? message["confirm"]! : message["setup"]!)
            : message["enter"]!;
      });
    }
  }

  void _onDone(String value) {
    bool wrong = false;
    if (widget.initCode) {
      //confirm code
      _confirm ? _reCode = value : _code = value;
      if (_confirm) {
        if (_reCode != _code) {
          wrong = true;
          _confirm = false;
        } else
          widget.initCode = false;
      }
      _confirm = !_confirm;
    } else {
      //do something after enter code
    }
    _changedTitle(wrongPIN: wrong);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                title.isEmpty ? message["setup"]! : title,
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            AnimatedBuilder(
              animation: offsetAnimation,
              builder: (context, child) => Container(
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                padding: EdgeInsets.only(
                    left: offsetAnimation.value + 24.0,
                    right: 24.0 - offsetAnimation.value),
                child: CodeInput(
                  length: 4,
                  builder: CodeInputBuilders.circle(
                      totalRadius: 20.0,
                      filledRadius: 15.0,
                      border: Border(),
                      color: Colors.white,
                      textStyle: TextStyle()),
                  keyboardType: TextInputType.number,
                  onDone: (value) => _onDone(value),
                  clearOnDone: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
