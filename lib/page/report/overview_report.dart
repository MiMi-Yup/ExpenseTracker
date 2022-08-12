import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class OverviewReport extends StatefulWidget {
  const OverviewReport({Key? key}) : super(key: key);

  @override
  State<OverviewReport> createState() => _OverviewReportState();
}

class _OverviewReportState extends State<OverviewReport> {
  int? indexPage;
  List<Widget Function(double)> pages = [
    (width) => ColoredBox(
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("You Spend 💸"),
              Text("\$332"),
              Padding(
                padding:
                    EdgeInsets.only(top: width * 0.125, bottom: width * 0.125),
                child: Container(
                  width: width * 0.75,
                  height: width * 0.75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: MyColor.purpleTranparent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("and your biggest"),
                      Container(),
                      Text("\$120")
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
              Text("You Spend 💸"),
              Text("\$332"),
              Padding(
                padding:
                    EdgeInsets.only(top: width * 0.125, bottom: width * 0.125),
                child: Container(
                  width: width * 0.75,
                  height: width * 0.75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: MyColor.purpleTranparent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("and your biggest"),
                      Container(),
                      Text("\$120")
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
              Text("quote"),
              Text("auth"),
              SizedBox(
                  width: double.maxFinite,
                  child: largestButton(
                      text: "See the full detail", onPressed: () => null))
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
