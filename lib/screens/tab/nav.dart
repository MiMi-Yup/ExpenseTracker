import 'dart:math' as math;
import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/enum/enum_transaction.dart';
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
  final Map<int, ItemNavModel?> _itemsNav = <int, ItemNavModel?>{
    0: ItemNavModel(icon: Icon(Icons.home), label: "Home"),
    1: ItemNavModel(icon: Icon(Icons.sync_alt), label: "Transaction"),
    2: ItemNavModel(icon: Icon(Icons.pie_chart), label: "Budget"),
    3: ItemNavModel(icon: Icon(Icons.person), label: "Profile"),
  };

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
  late AnimationController _controllerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex);
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final void Function(EPage) toPage = (page) => setState(() {
          _currentIndex = _mapPage[page]!;
          _controller.animateToPage(_currentIndex,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 250));
        });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                      parent: _controllerAnimation,
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
                      onPressed: () {},
                    ),
                  ),
                )).toList()
          ..add(
            FloatingActionButton(
              heroTag: null,
              child: AnimatedBuilder(
                  animation: _controllerAnimation,
                  builder: (context, child) => Transform(
                        transform: Matrix4.rotationZ(
                            _controllerAnimation.value * 0.5 * math.pi),
                        alignment: FractionalOffset.center,
                        child: Icon(_controllerAnimation.isDismissed
                            ? Icons.add
                            : Icons.close),
                      )),
              onPressed: () {
                if (_controllerAnimation.isDismissed) {
                  _controllerAnimation.forward();
                } else {
                  _controllerAnimation.reverse();
                }
              },
            ),
          ),
      ),
      bottomNavigationBar: bottomNavBar(
        itemsNav: _itemsNav,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _controller.animateToPage(_currentIndex,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 250));
          });
        },
      ),
      body: PageView.builder(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _itemsNav.length,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return HomePage(toPage: toPage);
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
