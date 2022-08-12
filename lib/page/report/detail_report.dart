import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/transaction_chart.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/item_transaction.dart';
import 'package:flutter/material.dart';

class DetailReport extends StatefulWidget {
  const DetailReport({Key? key}) : super(key: key);

  @override
  State<DetailReport> createState() => _DetailReportState();
}

class _DetailReportState extends State<DetailReport> {
  int indexTypeTransaction = 0;
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
        leading: IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
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
                dropDown(
                    isExpanded: false,
                    items: ["1", "2", "3"],
                    chosenValue: null,
                    onChanged: (value) => null),
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
                children: [LineChartSample1(), PieChartImage()],
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
                dropDown(
                    isExpanded: false,
                    items: ["Transaction", "Category"],
                    chosenValue: null,
                    onChanged: (value) => null),
                IconButton(onPressed: null, icon: Icon(Icons.filter_list))
              ],
            ),
            Expanded(
              child: ListView(
                children: List.generate(200, (index) => itemTransaction()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
