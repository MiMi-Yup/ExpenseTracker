import 'package:expense_tracker/constant/enum/enum_route.dart';
import 'package:expense_tracker/route.dart';
import 'package:expense_tracker/widget/input_otp.dart';
import 'package:flutter/material.dart';

class CodeAuth extends StatefulWidget {
  CodeAuth({Key? key}) : super(key: key);

  @override
  State<CodeAuth> createState() => _CodeAuthState();
}

class _CodeAuthState extends State<CodeAuth>
    with SingleTickerProviderStateMixin {
  
  late bool _initCode = ModalRoute.of(context)?.settings.arguments as bool;
  late bool _confirm = !_initCode;
  String _code = "";
  String _reCode = "";

  late AnimationController controller;
  final Map<String, String?> message = <String, String?>{
    "setup": "Let’s setup your PIN",
    "confirm": "Ok. Re type your PIN again",
    "enter": "Enter your PIN",
    "wrong": "Incorrect PIN, please try again"
  };
  late Animation<double> _offsetAnimation;

  String title = "";

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();

    _offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
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
        title = _initCode
            ? (_confirm ? message["confirm"]! : message["setup"]!)
            : message["enter"]!;
      });
    }
  }

  void _onDone(String value) {
    bool wrong = false;
    if (_initCode) {
      //confirm code
      _confirm ? _reCode = value : _code = value;
      if (_confirm) {
        if (_reCode != _code) {
          wrong = true;
        } else {
          //add pin completed. go to next
          _initCode = false;
        }
      }
      _confirm = !_confirm;
    } else {
      //do something after enter code
      //check account has been setup yet
      if (true) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushNamed(context,
            RouteApplication.getRoute(ERoute.introductionSetupAccount));
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushNamed(context, RouteApplication.getRoute(ERoute.main));
      }
    }
    _changedTitle(wrongPIN: wrong);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                title.isEmpty
                    ? _initCode
                        ? message["setup"]!
                        : message["enter"]!
                    : title,
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            AnimatedBuilder(
              animation: _offsetAnimation,
              builder: (context, child) => Container(
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                padding: EdgeInsets.only(
                    left: _offsetAnimation.value + 24.0,
                    right: 24.0 - _offsetAnimation.value),
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
                  autofocus: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
