import 'package:flutter/material.dart';

class ItemNavModel {
  String label;
  Icon icon;
  ItemNavModel({required this.icon, required this.label});
}

BottomNavigationBar bottomNavBar(
    {required Map<int, ItemNavModel?> itemsNav,
    required int currentIndex,
    required void Function(int index) onTap}) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.shifting,
    onTap: onTap,
    currentIndex: currentIndex,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    items: List<BottomNavigationBarItem>.generate(
        itemsNav.length,
        (index) => BottomNavigationBarItem(
            icon: itemsNav[index]!.icon, label: itemsNav[index]!.label)),
  );
}
