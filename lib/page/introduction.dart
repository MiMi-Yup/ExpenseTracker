import 'package:expense_tracker/constant/color.dart';
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
  final pages = 3;
  int currentPosition = 0;

  List<IntroductionModel> introductions = [
    IntroductionModel("asset/image/introduction_2.png", "Gain total control", "Become your own money manager"),
    IntroductionModel("asset/image/introduction_3.png", "Know where your", "Track your transaction easily"),
    IntroductionModel("asset/image/introduction_2.png", "Planing ahead", "Setup your budget for each category")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, index) => Column(
                children: [
                  Image.asset(introductions[index].imageAsset),
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
              itemCount: pages,
              controller: PageController(initialPage: currentPosition),
              onPageChanged: (value) => setState(() => currentPosition = value),
              allowImplicitScrolling: false,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Container>.generate(
                pages,
                (index) => Container(
                      width: index == currentPosition ? 20 : 10,
                      height: index == currentPosition ? 20 : 10,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: index == currentPosition
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
                onPressed: () => null,
                textColor: Colors.white,
                background: MyColor.purple(alpha: 255)),
          ),
          Container(
            width: double.maxFinite,
            height: 50,
            margin: EdgeInsets.all(10),
            child: largestButton(
                text: "Login",
                onPressed: () => null,
                textColor: MyColor.purple(alpha: 255),
                background: Colors.grey),
          )
        ],
      ),
    );
  }
}
