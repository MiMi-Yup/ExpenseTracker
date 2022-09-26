import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_user.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/auth/google_auth.dart';
import 'package:expense_tracker/services/firebase/firestore/user.dart';
import 'package:expense_tracker/widgets/input_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class CodeAuth extends StatefulWidget {
  CodeAuth({Key? key}) : super(key: key);

  @override
  State<CodeAuth> createState() => _CodeAuthState();
}

class _CodeAuthState extends State<CodeAuth>
    with SingleTickerProviderStateMixin {
  late bool _initCode = ModalRoute.of(context)?.settings.arguments as bool;
  late bool _confirm = !_initCode;
  final LocalAuthentication _authentication = LocalAuthentication();
  String _code = "";
  String _reCode = "";

  late AnimationController controller;
  final Map<String, String?> message = <String, String?>{
    "setup": "Let's setup your PIN",
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

  void _onDone(String value) async {
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

          await UserFirestore().read().then((value) async {
            if (value != null && value.isNotEmpty) {
              ModalUser fieldUser = value.first;
              fieldUser.passcode = _code;
              await UserFirestore().update(null, fieldUser);
            } else {
              await UserFirestore().insert(ModalUser(
                  id: null, email: null, password: null, passcode: _code));
            }
          });
        }
      }
      _confirm = !_confirm;
    } else {
      UserFirestore().read().then((user) {
        if (user != null) {
          if (user.isEmpty) {
            wrong = true;
          } else {
            bool allowAccess = user.first.passcode == value;
            if (allowAccess) {
              bool wasSetup = user.first.wasSetup ?? false;
              if (wasSetup) {
                RouteApplication.navigatorKey.currentState
                    ?.popUntil((route) => route.isFirst);
                RouteApplication.navigatorKey.currentState
                    ?.pushReplacementNamed(
                        RouteApplication.getRoute(ERoute.main));
              } else {
                RouteApplication.navigatorKey.currentState
                    ?.popUntil((route) => route.isFirst);
                RouteApplication.navigatorKey.currentState
                    ?.pushReplacementNamed(RouteApplication.getRoute(
                        ERoute.introductionSetupAccount));
              }
            }
          }
        }
      });
    }

    _changedTitle(wrongPIN: wrong);
  }

  Future<bool> checkFingerprint() async {
    try {
      return await _authentication.authenticate(
        localizedReason: 'Scan Fingerprint To Enter Vault',
        options: const AuthenticationOptions(
            useErrorDialogs: true, stickyAuth: true),
      );
    } on PlatformException {
      return false;
    }
  }

  bool? wasShowFragmentFingerPrint;

  Future<bool> canShowFragmentFingerprint() async {
    if (_initCode) return false;
    final bool isDeviceSupported = await _authentication.isDeviceSupported();
    final bool canCheckBiometrics = await _authentication.canCheckBiometrics;
    if (isDeviceSupported && canCheckBiometrics) return true;
    return false;
  }

  Future<void> showFragmentFingerprint() async {
    checkFingerprint().then((value) {
      if (value) {
        RouteApplication.navigatorKey.currentState
            ?.popUntil((route) => route.isFirst);
        RouteApplication.navigatorKey.currentState
            ?.pushReplacementNamed(RouteApplication.getRoute(ERoute.main));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Access deined because failed too much!")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        initialData: null,
        future: canShowFragmentFingerprint(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            showFragmentFingerprint();
          }

          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: MyColor.mainBackgroundColor,
                leading: null,
                actions: [
                  TextButton(
                    onPressed: () => showFragmentFingerprint(),
                    child: Text("By Biometrics"),
                  ),
                  TextButton(
                    onPressed: () async => await GoogleAuth.signOut(),
                    child: Text("Sign out"),
                  )
                ],
              ),
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
                          onDone: _onDone,
                          clearOnDone: true,
                          autofocus: snapshot.hasData
                              ? snapshot.data!
                                  ? false
                                  : true
                              : false,
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
