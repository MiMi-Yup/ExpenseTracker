import 'dart:math' as math;
import 'package:expense_tracker/page/budget/budget_page.dart';
import 'package:expense_tracker/page/home/home_page.dart';
import 'package:expense_tracker/page/profile/profile_page.dart';
import 'package:expense_tracker/page/transaction/transaction_page.dart';
import 'package:expense_tracker/widget/bottom_nav.dart';
import 'package:flutter/material.dart';

enum EPage { home, transaction, budget, profile }

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

  int _currentIndex = 0;
  late PageController _controller;
  late AnimationController _controllerAnimation;

  final List<IconData> icons = [Icons.sms, Icons.mail, Icons.phone];

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
        children: List.generate(icons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controllerAnimation,
                curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                //backgroundColor: backgroundColor,
                mini: true,
                child: Icon(
                  icons[index], /*color: foregroundColor*/
                ),
                onPressed: () {},
              ),
            ),
          );
          return child;
        }).toList()
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
                            ? Icons.share
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
