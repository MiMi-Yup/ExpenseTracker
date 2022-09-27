import 'dart:math' as math;
import 'dart:typed_data';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/screens/tab/budget/budget_page.dart';
import 'package:expense_tracker/screens/tab/home_page.dart';
import 'package:expense_tracker/screens/tab/profile/profile_page.dart';
import 'package:expense_tracker/screens/tab/transaction/transaction_page.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:expense_tracker/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

enum EPage { home, transaction, budget, profile }

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();

  static DateTime? _filterByDate;
  static DateTime get filterByDate {
    _filterByDate ??= DateTime.now();
    return _filterByDate!;
  }

  static void setState(BuildContext context, DateTime date) {
    _filterByDate = date;
    context.findAncestorStateOfType<_NavigationState>()?.setState(() {});
  }
}

class _NavigationState extends State<Navigation>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Map<EPage, int?> _mapPage = <EPage, int?>{
    EPage.home: 0,
    EPage.transaction: 1,
    EPage.budget: 2,
    EPage.profile: 3
  };

  late AnimationController _fabController;
  late TabController _tabController;

  bool keepAlive = true;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _tabController = TabController(
        initialIndex: 0,
        length: 4,
        animationDuration: const Duration(milliseconds: 250),
        vsync: this);
  }

  @override
  void dispose() {
    _fabController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void toPage(int page) {
      if (_mapPage.containsValue(page)) {
        _tabController.animateTo(page,
            curve: Curves.linear, duration: const Duration(milliseconds: 250));
        setState(() {});
      }
    }

    final Map<int, ItemNavModal?> _navActions = <int, ItemNavModal?>{
      0: ItemNavModal(
          icon: Icons.home, label: "Home", index: 0, toPage: toPage),
      1: ItemNavModal(
          icon: Icons.sync_alt, label: "Transaction", index: 1, toPage: toPage),
      2: ItemNavModal(icon: null, label: "Action", index: -1),
      3: ItemNavModal(
          icon: Icons.pie_chart, label: "Budget", index: 2, toPage: toPage),
      4: ItemNavModal(
          icon: Icons.person, label: "Profile", index: 3, toPage: toPage),
    };

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FutureBuilder<List<ModalTransactionType>?>(
        future: TransactionTypeFirestore().read(),
        initialData: const [],
        builder: (context, snapshot) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: snapshot.data!
                .map<Widget>((e) => Container(
                      height: 70.0,
                      width: 56.0,
                      alignment: FractionalOffset.topCenter,
                      child: ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _fabController,
                          curve: Interval(
                              0.0,
                              1.0 -
                                  (snapshot.data!.indexOf(e) /
                                          snapshot.data!.length) /
                                      2.0,
                              curve: Curves.easeOut),
                        ),
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.black,
                          mini: true,
                          child: e.localAsset != null && e.localAsset == true
                              ? Image.asset(
                                  e.image!,
                                  fit: BoxFit.contain,
                                  color: e.color,
                                )
                              : FutureBuilder<Uint8List?>(
                                  future: ActionFirebaseStorage.downloadFile(
                                      e.image!),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.hasData) {
                                      return Image.memory(snapshot.data!,
                                          color: e.color);
                                    }
                                    return SizedBox();
                                  }),
                          onPressed: () async {
                            await RouteApplication.navigatorKey.currentState
                                ?.pushNamed(
                                    RouteApplication.getRoute(
                                        ERoute.addEditTransaction),
                                    arguments:
                                        TransactionTypeFirestore().getRef(e));
                            _fabController.reverse();
                          },
                        ),
                      ),
                    ))
                .toList()
              ..add(
                FloatingActionButton(
                  heroTag: null,
                  elevation: 8.0,
                  child: AnimatedBuilder(
                      animation: _fabController,
                      builder: (context, child) => Transform(
                            transform: Matrix4.rotationZ(
                                _fabController.value * 0.5 * math.pi),
                            alignment: FractionalOffset.center,
                            child: Icon(_fabController.isDismissed
                                ? Icons.add
                                : Icons.close),
                          )),
                  onPressed: () async {
                    if (_fabController.isDismissed) {
                      _fabController.forward();
                    } else {
                      _fabController.reverse();
                    }
                  },
                ),
              ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarComponent(
              navActions: _navActions, currentIndex: _tabController.index)
          .builder(),
      body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            HomePage(toPage: (ePage) => toPage(_mapPage[ePage]!)),
            TransactionPage(),
            BudgetPage(),
            ProfilePage()
          ]),
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
