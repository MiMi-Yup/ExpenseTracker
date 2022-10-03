import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailReport extends StatefulWidget {
  const DetailReport({Key? key}) : super(key: key);

  @override
  State<DetailReport> createState() => _DetailReportState();
}

class _DetailReportState extends State<DetailReport> {
  int indexTypeTransaction = 0;
  String? indexTypeCategory;
  int indexChart = 0;

  late Size size = MediaQuery.of(context).size;
  late PageController _controllerChart;
  late PageController _controllerTypeTransaction;

  @override
  void initState() {
    _controllerChart = PageController(initialPage: indexChart);
    _controllerTypeTransaction =
        PageController(initialPage: indexTypeTransaction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => RouteApplication.navigatorKey.currentState
                ?.popUntil(ModalRoute.withName(
                    RouteApplication.getRoute(ERoute.main))),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text("Financial Report"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropDown<String>(
                    isExpanded: false,
                    hint: "Time",
                    items: ["Day", "Month", "Year"],
                    choseValue: null,
                    onChanged: (value) => null).builder(),
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey),
                    ),
                    Row(
                      children: List.generate(
                          2,
                          (index) => GestureDetector(
                                onTap: () => _controllerChart.animateToPage(
                                    index,
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.linear),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: index == indexChart
                                          ? MyColor.purple()
                                          : Colors.grey,
                                      borderRadius: index == 0
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0))
                                          : BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0))),
                                  child: index == 0
                                      ? Icon(Icons.show_chart,
                                          color: index == indexChart
                                              ? Colors.white
                                              : Colors.black)
                                      : Icon(Icons.pie_chart,
                                          color: index == indexChart
                                              ? Colors.white
                                              : Colors.black),
                                ),
                              )),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.3,
              child: PageView(
                onPageChanged: (value) => setState(() => indexChart = value),
                controller: _controllerChart,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // LineChart1(
                  //   lines: {
                  //     Color(0xff4af699): [
                  //       FlSpot(1, 1),
                  //       FlSpot(3, 1.5),
                  //       FlSpot(5, 1.4),
                  //       FlSpot(7, 3.4),
                  //       FlSpot(10, 2),
                  //       FlSpot(12, 2.2),
                  //       FlSpot(13, 8),
                  //     ],
                  //     Color(0xffaa4cfc): [
                  //       FlSpot(1, 1),
                  //       FlSpot(3, 2.8),
                  //       FlSpot(7, 1.2),
                  //       FlSpot(10, 2.8),
                  //       FlSpot(12, 2.6),
                  //       FlSpot(13, 3.9),
                  //     ],
                  //     Color(0xff27b6fc): [
                  //       FlSpot(1, 2.8),
                  //       FlSpot(3, 1.9),
                  //       FlSpot(6, 3),
                  //       FlSpot(10, 1.3),
                  //       FlSpot(13, 2.5),
                  //     ]
                  //   },
                  //   showBarData: true,
                  // ),
                  PieChartImage()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 40.0, right: 40.0),
              child: Stack(
                children: [
                  Container(
                      width: size.width - 100,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.grey)),
                  Row(
                    children: List.generate(
                        2,
                        (index) => GestureDetector(
                              onTap: () =>
                                  setState(() => indexTypeTransaction = index),
                              child: Container(
                                alignment: Alignment.center,
                                width: (size.width - 100) / 2,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: index == indexTypeTransaction
                                        ? MyColor.purple()
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: Text("Page"),
                              ),
                            )),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropDown<String>(
                    isExpanded: false,
                    hint: "View",
                    items: ["Transaction", "Category"],
                    choseValue: indexTypeCategory,
                    onChanged: (value) => indexTypeCategory = value).builder(),
                IconButton(onPressed: null, icon: Icon(Icons.filter_list))
              ],
            )
          ],
        ),
      ),
    );
  }
}
