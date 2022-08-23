import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/data.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/overview_transaction.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
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
                hintText: "Time",
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
            onTap: () => Navigator.pushNamed(
                context, RouteApplication.getRoute(ERoute.overviewReport)),
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
                  slivers: DataSample.sample.entries
                      .map((group) => group.value!.isNotEmpty
                          ? Section(
                              headerColor: MyColor.mainBackgroundColor,
                              titleColor: Colors.white,
                              title: group.key.toString(),
                              content: AnimatedList(
                                  shrinkWrap: true,
                                  initialItemCount: group.value!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index, animation) {
                                    ModalTransaction modal =
                                        group.value![index];
                                    return SizeTransition(
                                      sizeFactor: animation,
                                      child: TransactionComponent(modal: modal)
                                          .builder(
                                        isEditable: true,
                                        onTap: () async {
                                          await Navigator.pushNamed(
                                              context,
                                              RouteApplication.getRoute(
                                                  ERoute.detailTransaction),
                                              arguments: [modal, true]);
                                          setState(() {});
                                        },
                                        editSlidableAction: (context) async {
                                          await Navigator.pushNamed(
                                              context,
                                              RouteApplication.getRoute(
                                                  ERoute.addEditTransaction),
                                              arguments: modal);
                                          setState(() {});
                                        },
                                        deleteSlidableAction: (context) {
                                          AnimatedList.of(context).removeItem(
                                              index,
                                              (_, animation) => SizeTransition(
                                                    sizeFactor: animation,
                                                    child: TransactionComponent(
                                                            modal: modal)
                                                        .builder(
                                                            isEditable: false),
                                                  ),
                                              duration:
                                                  const Duration(seconds: 1));
                                          group.value!.removeAt(index);
                                        },
                                      ),
                                    );
                                  }))
                          : SliverPadding(padding: EdgeInsets.all(0)))
                      .toList()))
        ],
      ),
    );
  }
}
