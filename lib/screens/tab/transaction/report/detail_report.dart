import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/component/category_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
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
            onPressed: () => Navigator.popUntil(context,
                ModalRoute.withName(RouteApplication.getRoute(ERoute.main))),
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
                dropDown(
                    isExpanded: false,
                    hintText: "Time",
                    items: ["Day", "Month", "Year"],
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
                    hintText: "View",
                    items: ["Transaction", "Category"],
                    chosenValue: indexTypeCategory,
                    onChanged: (value) =>
                        setState(() => indexTypeCategory = value)),
                IconButton(onPressed: null, icon: Icon(Icons.filter_list))
              ],
            ),
            Expanded(
              child: ListView(
                children: List.generate(
                    200,
                    (index) => indexTypeCategory == "Category"
                        ? CategoryComponent(
                                modal: ModalBudget(
                                    budgetMoney: 0.0,
                                    nowMoney: 0.0,
                                    isLimited: false,
                                    category: ECategory.shopping,
                                    currency: '\$'))
                            .percentCategoryBuilder(width: size.width)
                        : TransactionComponent(
                            modal: ModalTransaction(
                                category: ECategory.bill,
                                money: index * 1.683,
                                timeTransaction: DateTime.now(),
                                typeTransaction: index % 2 == 0
                                    ? ETypeTransaction.income
                                    : ETypeTransaction.expense,
                                account: "Paypal",
                                isRepeat: false,
                                purpose: 'Buy electronic',
                                currency: '\$'),
                            isEditable: false,
                            onTap: () => Navigator.pushNamed(
                                context,
                                RouteApplication.getRoute(
                                    ERoute.detailTransaction),
                                arguments: null),
                          )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
