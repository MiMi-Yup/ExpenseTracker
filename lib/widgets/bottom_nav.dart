import 'package:flutter/material.dart';

class ItemNavModal {
  int index;
  String? label;
  IconData? icon;
  void Function(int)? toPage;
  ItemNavModal({required this.index, this.label, this.icon, this.toPage});
}

class BottomAppBarComponent {
  Map<int, ItemNavModal?> navActions;
  int currentIndex;
  BottomAppBarComponent({required this.navActions, required this.currentIndex});

  Widget builder() {
    return StatefulBuilder(builder: (context, setState) {
      return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navActions.entries
              .map((e) => TextButton(
                    onPressed: e.value!.index >= 0
                        ? () {
                            if (e.value!.index >= 0) {
                              setState(() => currentIndex = e.value!.index);
                              if (e.value?.toPage != null) {
                                e.value!.toPage!(e.value!.index);
                              }
                            }
                          }
                        : null,
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            e.value?.icon,
                            color: currentIndex == e.value!.index
                                ? Colors.white
                                : Colors.grey,
                          ),
                          Visibility(
                            child: Text(
                              e.value?.label ?? "",
                              style: TextStyle(color: Colors.white),
                            ),
                            visible: currentIndex == e.value!.index,
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    });
  }
}
