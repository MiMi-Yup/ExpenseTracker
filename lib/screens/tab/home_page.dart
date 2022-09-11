import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_notification.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/screens/tab/nav.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/notification.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/overview_transaction_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  void Function(EPage)? toPage;
  HomePage({Key? key, this.toPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late PageController _controller;

  final TransactionUtilities service = TransactionUtilities();

  final List<Widget> _charts = [
    LineChartSample1(),
    Text("data"),
    Text("data"),
    Text("data")
  ];
  int _currentIndex = 0;
  late double height = MediaQuery.of(context).size.height;

  final List<OverviewTransactionComponent> overview_transaction =
      TranasactionTypeInstance.instance()
          .modals!
          .map((e) => OverviewTransactionComponent(
              transactionTypeRef: TransactionTypeFirestore().getRef(e!),
              money: 3000))
          .toList();

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
                        backgroundImage: NetworkImage(
                            UserInstance.instance().getModal().photoURL!,
                            scale: 1.0)),
                  ),
                ),
                title: DropDown<String>(
                    hint: "Time",
                    isExpanded: false,
                    items: ["1", "2", "3"],
                    choseValue: null,
                    onChanged: (p0) => null).builder(),
                actions: [
                  IconButton(
                      onPressed: () =>
                          RouteApplication.navigatorKey.currentState?.pushNamed(
                              RouteApplication.getRoute(ERoute.notification)),
                      icon: StreamBuilder<QuerySnapshot<ModalNotification>>(
                        stream: NotificationFirestore().stream,
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
                            children: <Widget>[
                              Icon(Icons.notifications),
                              if (indicator != null) indicator
                            ],
                          );
                        },
                      ))
                ],
              ),
              Text("Account balance"),
              Text(
                "\$9400",
                style: TextStyle(fontSize: 30.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
              ).builder(),
              Section(
                  title: "Spend Frequency",
                  headerColor: MyColor.mainBackgroundColor,
                  titleColor: Colors.white,
                  action: Text("See all"),
                  onPressed: () => widget.toPage!(EPage.transaction),
                  content: StreamBuilder<QuerySnapshot<ModalTransactionLog>>(
                    initialData: null,
                    stream: CurrentTransaction().stream,
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
                                      builder: (context, snapshot) => snapshot
                                              .hasData
                                          ? TransactionComponent(
                                              modal: snapshot.data!,
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
                                                      false
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
                                                        arguments:
                                                            snapshot.data!);
                                              },
                                              deleteSlidableAction:
                                                  (context) async {
                                                await service
                                                    .delete(snapshot.data!);
                                              },
                                            )
                                          : LinearProgressIndicator());
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
  bool get wantKeepAlive => true;
}
