import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_account.dart';
import 'package:expense_tracker/modals/modal_notification.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/screens/tab/nav.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/screens/tab/utils_screen.dart';
import 'package:expense_tracker/services/firebase/firestore/accounts.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/notification.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/fliter_month_component.dart';
import 'package:expense_tracker/widgets/component/overview_transaction_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  void Function(EPage)? toPage;
  HomePage({Key? key, this.toPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _controller;

  final TransactionUtilities serviceTransaction = TransactionUtilities();
  final CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();
  final AccountFirestore serviceAccount = AccountFirestore();
  final NotificationFirestore serviceNotification = NotificationFirestore();

  int _currentIndex = 0;
  late double height = MediaQuery.of(context).size.height;

  bool keepAlive = true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: 3,
        vsync: this,
        initialIndex: _currentIndex,
        animationDuration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _charts = [
      TodayLineChart(
        lines: {
          Color(0xff4af699): [
            FlSpot(1, 1),
            FlSpot(2, 1.5),
            FlSpot(3, 1.4),
            FlSpot(5, 3.4),
            FlSpot(7, 2),
            FlSpot(9, 2.2),
            FlSpot(12, 10),
            FlSpot(14, 12),
            FlSpot(16, 1.5),
            FlSpot(18, 1.4),
            FlSpot(20, 3.4),
            FlSpot(22, 18),
            FlSpot(24, 22)
          ],
          Color(0xffaa4cfc): [
            FlSpot(1, 1),
            FlSpot(2, 2.8),
            FlSpot(3, 1.2),
            FlSpot(5, 2.8),
            FlSpot(6, 2.6),
            FlSpot(9, 16),
            FlSpot(10, 3.9),
            FlSpot(12, 3.9),
            FlSpot(14, 1),
            FlSpot(16, 2.8),
            FlSpot(18, 1.2),
            FlSpot(20, 2.8),
            FlSpot(22, 2.6),
            FlSpot(24, 3.9)
          ]
        },
        showBarData: true,
        currency: UserInstance.instance().defaultCurrencyAccount?.currencyCode,
        unitHorizontal: 'h',
      ),
      WeekLineChart(
        lines: {
          Color(0xff4af699): [
            FlSpot(1, 1),
            FlSpot(1.2, 1.5),
            FlSpot(1.5, 1.4),
            FlSpot(2.5, 3.4),
            FlSpot(3.5, 2),
            FlSpot(3.8, 2.2)
          ],
          Color(0xffaa4cfc): [
            FlSpot(1, 1),
            FlSpot(1.5, 2.8),
            FlSpot(2, 1.2),
            FlSpot(2.5, 2.8),
            FlSpot(3, 2.6),
            FlSpot(3.5, 3.9),
            FlSpot(4, 3.9),
          ]
        },
        showBarData: true,
        currency: UserInstance.instance().defaultCurrencyAccount?.currencyCode,
      ),
      MonthLineChart(
        lines: {
          Color(0xff4af699): [
            FlSpot(1, 1),
            FlSpot(2, 1.5),
            FlSpot(3, 1.4),
            FlSpot(4, 3.4),
            FlSpot(5, 2),
            FlSpot(6, 2.2),
            FlSpot(7, 1),
            FlSpot(8, 1.5),
            FlSpot(9, 1.4),
            FlSpot(10, 3.4),
            FlSpot(11, 2),
            FlSpot(12, 2.2)
          ],
          Color(0xffaa4cfc): [
            FlSpot(1, 1),
            FlSpot(2, 2.8),
            FlSpot(3, 1.2),
            FlSpot(4, 2.8),
            FlSpot(5, 2.6),
            FlSpot(6, 3.9),
            FlSpot(7, 3.9),
            FlSpot(8, 1),
            FlSpot(9, 2.8),
            FlSpot(10, 1.2),
            FlSpot(11, 2.8),
            FlSpot(12, 2.6)
          ]
        },
        showBarData: true,
        currency: UserInstance.instance().defaultCurrencyAccount?.currencyCode,
      )
    ];
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
                    child: (UserInstance.instance().modal != null &&
                            UserInstance.instance().modal?.photoURL != null)
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                UserInstance.instance().modal!.photoURL!,
                                scale: 1.0))
                        : null,
                  ),
                ),
                title: FilterTransactionByMonthComponent(
                        onChanged: (value) {
                          setState(() => Navigation.setState(context, value));
                          RouteApplication.navigatorKey.currentState?.pop();
                        },
                        setInitDateTime: Navigation.filterByDate == null
                            ? (value) => WidgetsBinding.instance
                                .addPostFrameCallback((_) => setState(
                                    () => Navigation.setState(context, value)))
                            : null,
                        selectedDate: Navigation.filterByDate)
                    .builder(),
                actions: [
                  IconButton(
                      onPressed: () =>
                          RouteApplication.navigatorKey.currentState?.pushNamed(
                              RouteApplication.getRoute(ERoute.notification)),
                      icon: StreamBuilder<QuerySnapshot<ModalNotification>>(
                        stream: serviceNotification.stream,
                        builder: (context, snapshot) {
                          Widget? indicator;
                          if (snapshot.hasData) {
                            int size = snapshot.data!.docs
                                .where(
                                    (element) => element.data().isRead == false)
                                .length;
                            if (size > 0) {
                              indicator = Positioned(
                                right: 0.0,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    '$size',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          }

                          return Stack(
                            children: [
                              Icon(Icons.notifications),
                              if (indicator != null) indicator
                            ],
                          );
                        },
                      ))
                ],
              ),
              Text("Accounts balance"),
              FutureBuilder<List<ModalAccount>?>(
                  future: serviceAccount.read(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      double totalMoney = 0.0;
                      for (var element in snapshot.data!) {
                        totalMoney += element.money ?? 0.0;
                      }
                      return Text(
                        "${UserInstance.instance().defaultCurrencyAccount?.currencyCode} ${MultiCurrency.convertBalanceToCurrency(targetCurrency: UserInstance.instance().defaultCurrencyAccount!, modals: snapshot.data!).toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 30.0),
                      );
                    } else {
                      return LinearProgressIndicator();
                    }
                  }),
              StreamBuilder<QuerySnapshot<ModalTransactionLog>>(
                  initialData: null,
                  stream: serviceLog.stream,
                  builder: (context, snapshot) {
                    return FutureBuilder<
                        Map<ModalTransactionType, List<ModalTransaction>?>>(
                      initialData: null,
                      future:
                          serviceTransaction.groupTransactionByTransactionType(
                              filterByDate: Navigation.filterByDate),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: snapshot.data!.keys.map((modalType) {
                                return FutureBuilder<double>(
                                    initialData: null,
                                    future: MultiCurrency
                                        .convertTransactionByCurrency(
                                            targetCurrency:
                                                UserInstance.instance()
                                                    .defaultCurrencyAccount!,
                                            modals: snapshot.data![modalType]!),
                                    builder: (context, snapshot) => snapshot
                                            .hasData
                                        ? OverviewTransactionComponent(
                                                modal: modalType,
                                                money: snapshot.data! < 0
                                                    ? snapshot.data! * -1.0
                                                    : snapshot.data!,
                                                currency:
                                                    UserInstance.instance()
                                                        .defaultCurrencyAccount)
                                            .builder()
                                        : SizedBox(
                                            width: 100,
                                            child: LinearProgressIndicator()));
                              }).toList(),
                            ),
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    );
                  })
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: height / 3.5,
                        child: TabBarView(
                          children: _charts,
                          controller: _controller,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List<GestureDetector>.generate(
                              _charts.length,
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
                                      setState(() =>
                                          _controller.animateTo(_currentIndex));
                                    },
                                  )))
                    ],
                  ),
                ),
              ).builder(),
              Section(
                  title: "Spend Frequency",
                  headerColor: MyColor.mainBackgroundColor,
                  titleColor: Colors.white,
                  action: Text("See all"),
                  onPressed: () => widget.toPage!(EPage.transaction),
                  content: StreamBuilder<QuerySnapshot<ModalTransactionLog>>(
                    initialData: null,
                    stream: serviceLog.stream,
                    builder: (context, snapshot) {
                      QuerySnapshot<ModalTransactionLog>? query = snapshot.data;
                      return query == null
                          ? const Center(child: Text("Empty list transaction"))
                          : MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              removeBottom: false,
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: query.docs.map((e) {
                                  ModalTransactionLog log = e.data();
                                  DocumentReference docRef =
                                      log.lastTransactionRef ??
                                          log.firstTransactionRef!;
                                  return FutureBuilder<ModalTransaction?>(
                                      future: TransactionFirestore()
                                          .getModalFromRef(docRef),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          ModalTransaction modal =
                                              snapshot.data!;
                                          if (modal.getTimeCreate?.year ==
                                                  Navigation
                                                      .filterByDate.year &&
                                              modal.getTimeCreate?.month ==
                                                  Navigation
                                                      .filterByDate.month) {
                                            return TransactionComponent(
                                              modal: modal,
                                              isEditable: true,
                                              onTap: () async {
                                                await RouteApplication
                                                    .navigatorKey.currentState
                                                    ?.pushNamed(
                                                        RouteApplication
                                                            .getRoute(ERoute
                                                                .detailTransaction),
                                                        arguments: [
                                                      snapshot.data!,
                                                      true,
                                                      true
                                                    ]);
                                                setState(() {});
                                              },
                                              editSlidableAction: (context) {
                                                RouteApplication
                                                    .navigatorKey.currentState
                                                    ?.pushNamed(
                                                        RouteApplication
                                                            .getRoute(ERoute
                                                                .addEditTransaction),
                                                        arguments: modal);
                                              },
                                              deleteSlidableAction:
                                                  (context) async {
                                                await serviceTransaction
                                                    .delete(modal);
                                              },
                                            );
                                          }
                                          return SizedBox();
                                        } else {
                                          return LinearProgressIndicator();
                                        }
                                      });
                                }).toList(),
                              ));
                    },
                  )).builder()
            ]),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
