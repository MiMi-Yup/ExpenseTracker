import 'package:expense_tracker/constant/color.dart';
import 'package:expense_tracker/page/home/home_page.dart';
import 'package:expense_tracker/page/transaction/transaction_page.dart';
import 'package:expense_tracker/widget/bottom_nav.dart';
import 'package:expense_tracker/widget/dropdown.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final Map<int, ItemNavModel?> _itemsNav = <int, ItemNavModel?>{
    0: ItemNavModel(icon: Icon(Icons.home), label: "Home"),
    1: ItemNavModel(icon: Icon(Icons.sync_alt), label: "Transaction"),
    2: ItemNavModel(icon: Icon(Icons.pie_chart), label: "Budget"),
    3: ItemNavModel(icon: Icon(Icons.person), label: "Profile"),
  };

  int _currentIndex = 0;
  late PageController _controller;

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
    return Scaffold(
      bottomNavigationBar: bottomNavBar(
        itemsNav: _itemsNav,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _controller.animateToPage(_currentIndex,
              curve: Curves.linear, duration: Duration(milliseconds: 250));
        },
      ),
      body: PageView.builder(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _itemsNav.length,
          itemBuilder: (context, index) =>
              index == 0 ? HomePage() : TransactionPage()),
    );
  }
}
