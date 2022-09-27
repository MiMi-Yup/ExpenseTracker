import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';

class OverviewReport extends StatefulWidget {
  const OverviewReport({Key? key}) : super(key: key);

  @override
  State<OverviewReport> createState() => _OverviewReportState();
}

class _OverviewReportState extends State<OverviewReport> {
  late PageController _controller;
  int indexPage = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: indexPage);
    super.initState();
  }

  late List<Widget Function(double)> pages = [
    (width) => ColoredBox(
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You Earned 💰",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  Text("\$332",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              )),
              Padding(
                padding:
                    EdgeInsets.only(top: width * 0.125, bottom: width * 0.125),
                child: Container(
                  width: width * 0.75,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: MyColor.purpleTranparent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("and your biggest",
                          style: TextStyle(color: Colors.black)),
                      // CategoryComponent(
                      //         modal: ModalBudget(
                      //             budgetMoney: 0.0,
                      //             nowMoney: 0.0,
                      //             isLimited: false,
                      //             category: ECategory.shopping,
                      //             currency: '\$'))
                      //     .nameCategoryBuilder(),
                      Text("\$120", style: TextStyle(color: Colors.black))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    (width) => ColoredBox(
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You Spend 💸",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  Text("\$332",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              )),
              Padding(
                padding:
                    EdgeInsets.only(top: width * 0.125, bottom: width * 0.125),
                child: Container(
                  width: width * 0.75,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: MyColor.purpleTranparent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("and your biggest",
                          style: TextStyle(color: Colors.black)),
                      // CategoryComponent(
                      //         modal: ModalBudget(
                      //             budgetMoney: 0.0,
                      //             nowMoney: 0.0,
                      //             isLimited: false,
                      //             category: ECategory.shopping,
                      //             currency: '\$'))
                      //     .nameCategoryBuilder(),
                      Text("\$120", style: TextStyle(color: Colors.black))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    (width) => ColoredBox(
          color: MyColor.purple(alpha: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("Quote"), Text("auth")],
                    )),
              )),
              Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(10.0),
                  child: largestButton(
                      text: "See the full detail",
                      onPressed: () => RouteApplication
                          .navigatorKey.currentState
                          ?.popAndPushNamed(
                              RouteApplication.getRoute(ERoute.detailReport))))
            ],
          ),
        )
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            allowImplicitScrolling: true,
            children: pages.map((e) => e(width)).toList(),
            onPageChanged: (value) => setState(() => indexPage = value),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 25, right: 25),
              child: Stack(
                children: [
                  Container(
                    width: width - 50,
                    height: 8.0,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                  Row(
                    children: List.generate(
                        3,
                        (index) => Container(
                              width: (width - 50) / 3,
                              height: 8.0,
                              decoration: BoxDecoration(
                                  color: index == indexPage
                                      ? Colors.white
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(4.0)),
                            )),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
