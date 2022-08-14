import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/widget/transaction_chart.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/item_transaction.dart';
import 'package:expense_tracker/widget/overview_transaction.dart';
import 'package:expense_tracker/widget/section.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _controller;

  final List<Widget> _charts = [
    LineChartSample1(),
    Text("data"),
    Text("data"),
    Text("data")
  ];
  int _currentIndex = 0;
  late double height = MediaQuery.of(context).size.height;
  final List<OverviewTransaction> overview_transaction = [
    OverviewTransaction("income", currency: "\$", value: 5000),
    OverviewTransaction("expense", currency: "\$", value: 3000)
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: GestureDetector(
                  onTap: null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        backgroundColor: MyColor.purple(),
                        foregroundImage:
                            AssetImage("asset/image/paypal_bank.png")),
                  ),
                ),
                title: dropDown(
                    isExpanded: false,
                    items: ["1", "2", "3"],
                    chosenValue: null,
                    onChanged: (p0) => null),
                actions: [
                  IconButton(onPressed: null, icon: Icon(Icons.notifications))
                ],
              ),
              Text("Account balance"),
              Text(
                "\$9400",
                style: TextStyle(fontSize: 30.0),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: overview_transaction
                      .map<GestureDetector>(
                          (e) => overviewTransaction(typeTransaction: e))
                      .toList(),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
              Section(
                title: "Spend Frequency",
                headerColor: MyColor.mainBackgroundColor,
                titleColor: Colors.white,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          height: height / 4,
                          child: PageView.builder(
                            physics: BouncingScrollPhysics(),
                            controller: _controller,
                            itemCount: _charts.length,
                            itemBuilder: (context, index) => _charts[index],
                            onPageChanged: (value) =>
                                setState(() => _currentIndex = value),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List<GestureDetector>.generate(
                              4,
                              (index) => GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                          left: 16.0,
                                          right: 16.0),
                                      decoration: BoxDecoration(
                                          color: index == _currentIndex
                                              ? Colors.amber
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(index.toString()),
                                    ),
                                    onTap: () {
                                      _currentIndex = index;
                                      setState(() => _controller
                                          .jumpToPage(_currentIndex));
                                    },
                                  )))
                    ],
                  ),
                ),
              ),
              Section(
                  title: "Spend Frequency",
                  headerColor: MyColor.mainBackgroundColor,
                  titleColor: Colors.white,
                  titleButton: "See all",
                  content: Column(
                    children:
                        List<Widget>.generate(50, (index) => itemTransaction()),
                  ))
            ]),
          ),
        )
      ],
    );
  }
}
