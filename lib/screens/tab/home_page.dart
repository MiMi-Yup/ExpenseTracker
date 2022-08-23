import 'package:expense_tracker/constants/asset/category.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/instances/data.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/screens/tab/nav.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/component/overview_transaction_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/overview_transaction.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  void Function(EPage)? toPage;
  HomePage({Key? key, this.toPage}) : super(key: key);

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
  final List<OverviewTransactionComponent> overview_transaction = [
    OverviewTransactionComponent(
        typeTransaction: ETypeTransaction.income, currency: "\$", money: 5000),
    OverviewTransactionComponent(
        typeTransaction: ETypeTransaction.expense, currency: "\$", money: 3000)
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
                  onTap: () => widget.toPage!(EPage.profile),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        backgroundColor: MyColor.purple(),
                        foregroundImage: AssetImage(CategoryAsset.moneyBag)),
                  ),
                ),
                title: dropDown(
                    hintText: "Time",
                    isExpanded: false,
                    items: ["1", "2", "3"],
                    chosenValue: null,
                    onChanged: (p0) => null),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.pushNamed(context,
                          RouteApplication.getRoute(ERoute.notification)),
                      icon: Icon(Icons.notifications))
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
                  children:
                      overview_transaction.map((e) => e.builder()).toList(),
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
                  onPressed: () => widget.toPage!(EPage.transaction),
                  content: AnimatedList(
                      shrinkWrap: true,
                      initialItemCount: DataSample.convertToList().length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index, animation) {
                        ModalTransaction modal =
                            DataSample.convertToList()[index];
                        return SizeTransition(
                          sizeFactor: animation,
                          child: TransactionComponent(modal: modal).builder(
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
                                        child:
                                            TransactionComponent(modal: modal)
                                                .builder(isEditable: false),
                                      ),
                                  duration: const Duration(seconds: 1));
                              DataSample.convertToList().remove(modal);
                            },
                          ),
                        );
                      }))
            ]),
          ),
        )
      ],
    );
  }
}
