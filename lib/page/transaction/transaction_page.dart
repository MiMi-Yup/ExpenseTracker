import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/constant/enum/enum_category.dart';
import 'package:expense_tracker/constant/enum/enum_route.dart';
import 'package:expense_tracker/constant/enum/enum_transaction.dart';
import 'package:expense_tracker/page/add_edit_transaction/modal_transaction.dart';
import 'package:expense_tracker/route.dart';
import 'package:expense_tracker/widget/transaction_chart.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:expense_tracker/widget/item_transaction.dart';
import 'package:expense_tracker/widget/overview_transaction.dart';
import 'package:expense_tracker/widget/section.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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

  bool hasFilter = false;

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
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dropDown(
                isExpanded: false,
                items: ["1", "2"],
                chosenValue: null,
                onChanged: (p0) => null,
              ),
              IconButton(
                  onPressed: () async => showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Filter Transaction"),
                                    TextButton(
                                        onPressed: null, child: Text("Reset"))
                                  ],
                                ),
                                Text("Fiter by"),
                                Align(
                                  alignment: Alignment.center,
                                  child: Wrap(
                                    spacing: 8.0,
                                    children: List<Widget>.generate(
                                      3,
                                      (int index) {
                                        return ChoiceChip(
                                          label: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text("fsdf"),
                                          ),
                                          //selected: _value == index,
                                          selected: false,
                                          onSelected: (selected) {
                                            // setState(() {
                                            //   _value = selected ? index : null;
                                            // });
                                          },
                                          selectedColor: Colors.white70,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                                Text("Sort by"),
                                Align(
                                  alignment: Alignment.center,
                                  child: Wrap(
                                    spacing: 8.0,
                                    children: List<Widget>.generate(
                                      5,
                                      (int index) {
                                        return ChoiceChip(
                                          label: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text("fsdf"),
                                          ),
                                          //selected: _value == index,
                                          selected: false,
                                          onSelected: (selected) {
                                            // setState(() {
                                            //   _value = selected ? index : null;
                                            // });
                                          },
                                          selectedColor: Colors.white70,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                                Text("Category"),
                                Visibility(
                                    child: Container(
                                  color: Colors.yellow,
                                )),
                              ]),
                        ),
                      ),
                  icon: Icon(Icons.sort,
                      color: hasFilter ? MyColor.purple() : null))
            ],
          ),
          GestureDetector(
            onTap: null,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: MyColor.purpleTranparent,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "See your financial report",
                    style: TextStyle(color: MyColor.purple()),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: MyColor.purple(),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: List.generate(
                5,
                (index) => Section(
                      headerColor: MyColor.mainBackgroundColor,
                      titleColor: Colors.white,
                      content: Column(
                        children: List.generate(
                            5,
                            (index) => ItemTransaction(
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
                                            currency: '\$'))
                                    .builder(
                                  onTap: () => Navigator.pushNamed(
                                      context,
                                      RouteApplication.getRoute(
                                          ERoute.detailTransaction),
                                      arguments: null),
                                )),
                      ),
                      title: "fsdkjhf",
                    )),
          ))
        ],
      ),
    );
  }
}
