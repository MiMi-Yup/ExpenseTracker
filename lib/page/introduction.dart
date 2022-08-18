import 'dart:async';

import 'package:expense_tracker/constant/asset/background.dart';
import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/constant/route.dart';
import 'package:expense_tracker/route.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';

class IntroductionModel {
  String imageAsset;
  String title;
  String subTitle;
  IntroductionModel(this.imageAsset, this.title, this.subTitle);
}

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final _pages = 3;
  int _currentPosition = 0;
  late PageController _controller;
  late Timer _timer;
  bool _endPage = false;

  List<IntroductionModel> introductions = [
    IntroductionModel(BackgroundAsset.introduction1, "Gain total control",
        "Become your own money manager"),
    IntroductionModel(BackgroundAsset.introduction2, "Know where your",
        "Track your transaction easily"),
    IntroductionModel(BackgroundAsset.introduction1, "Planing ahead",
        "Setup your budget for each category")
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentPosition);
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      switch (_currentPosition) {
        case 0:
          _endPage = false;
          break;
        case 2:
          _endPage = true;
          break;
        default:
      }
      _endPage
          ? _controller.previousPage(
              duration: const Duration(milliseconds: 250), curve: Curves.linear)
          : _controller.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => Column(
                children: [
                  Expanded(
                      child: Image.asset(
                    introductions[index].imageAsset,
                    fit: BoxFit.contain,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(introductions[index].title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(introductions[index].subTitle,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 25,
                            fontWeight: FontWeight.normal)),
                  )
                ],
              ),
              itemCount: _pages,
              controller: _controller,
              onPageChanged: (value) =>
                  setState(() => _currentPosition = value),
              allowImplicitScrolling: false,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Container>.generate(
                _pages,
                (index) => Container(
                      width: index == _currentPosition ? 20 : 10,
                      height: index == _currentPosition ? 20 : 10,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: index == _currentPosition
                              ? Colors.white
                              : Colors.grey,
                          shape: BoxShape.circle),
                    )),
          ),
          Container(
            width: double.maxFinite,
            height: 50,
            margin: EdgeInsets.all(10),
            child: largestButton(
                text: "Sign Up",
                onPressed: () => Navigator.pushNamed(
                    context, RouteApplication.getRoute(ERoute.signUp)),
                textColor: Colors.white,
                background: MyColor.purple(alpha: 255)),
          ),
          Container(
            width: double.maxFinite,
            height: 50,
            margin: EdgeInsets.all(10),
            child: largestButton(
                text: "Login",
                onPressed: () => Navigator.pushNamed(
                    context, RouteApplication.getRoute(ERoute.pin),
                    arguments: false),
                textColor: MyColor.purple(alpha: 255),
                background: Colors.grey),
          )
        ],
      ),
    );
  }
}
