import 'dart:math' as math;
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/screens/tab/budget_page.dart';
import 'package:expense_tracker/screens/tab/home_page.dart';
import 'package:expense_tracker/screens/tab/profile/profile_page.dart';
import 'package:expense_tracker/screens/tab/transaction/transaction_page.dart';
import 'package:expense_tracker/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

enum EPage { home, transaction, budget, profile }

class _FloatingActionData {
  String asset;
  ETypeTransaction type;
  _FloatingActionData({required this.asset, required this.type});
}

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with TickerProviderStateMixin {
  final Map<EPage, int?> _mapPage = <EPage, int?>{
    EPage.home: 0,
    EPage.transaction: 1,
    EPage.budget: 2,
    EPage.profile: 3
  };

  final List<_FloatingActionData> _floatingActions = [
    _FloatingActionData(asset: IconAsset.income, type: ETypeTransaction.income),
    _FloatingActionData(
        asset: IconAsset.expense, type: ETypeTransaction.expense)
  ];

  int _currentIndex = 0;
  late PageController _controller;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex);
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final void Function(int) toPage = (page) {
      if (_mapPage.containsValue(page)) {
        _controller.animateToPage(page,
            curve: Curves.linear, duration: const Duration(milliseconds: 250));
      }
    };

    final Map<int, ItemNavModal?> _navActions = <int, ItemNavModal?>{
      0: ItemNavModal(
          icon: Icons.home, label: "Home", index: 0, toPage: toPage),
      1: ItemNavModal(
          icon: Icons.sync_alt, label: "Transaction", index: 1, toPage: toPage),
      2: ItemNavModal(icon: Icons.add, label: "Action", index: -1),
      3: ItemNavModal(
          icon: Icons.pie_chart, label: "Budget", index: 2, toPage: toPage),
      4: ItemNavModal(
          icon: Icons.person, label: "Profile", index: 3, toPage: toPage),
    };

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
            _floatingActions.length,
            (index) => Container(
                  height: 70.0,
                  width: 56.0,
                  alignment: FractionalOffset.topCenter,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _fabController,
                      curve: Interval(
                          0.0, 1.0 - index / _floatingActions.length / 2.0,
                          curve: Curves.easeOut),
                    ),
                    child: FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Colors.black,
                      mini: true,
                      child: Image.asset(
                        _floatingActions[index].asset,
                        fit: BoxFit.contain,
                      ),
                      onPressed: () async {
                        await Navigator.pushNamed(
                            context,
                            RouteApplication.getRoute(
                                ERoute.addEditTransaction),
                            arguments: _floatingActions[index].type);
                        //if (reload != null && reload) setState(() {});
                      },
                    ),
                  ),
                )).toList()
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
              onPressed: () {
                if (_fabController.isDismissed) {
                  _fabController.forward();
                } else {
                  _fabController.reverse();
                }
              },
            ),
          ),
      ),
      bottomNavigationBar: BottomAppBarComponent(
              navActions: _navActions, currentIndex: _currentIndex)
          .builder(),
      body: PageView.builder(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _navActions.length - 1,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return HomePage(toPage: (ePage) => toPage(_mapPage[ePage]!));
              case 1:
                return TransactionPage();
              case 2:
                return BudgetPage();
              case 3:
                return ProfilePage();
              default:
                return Container();
            }
          }),
    );
  }
}
