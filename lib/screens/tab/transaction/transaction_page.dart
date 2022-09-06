import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/overview_transaction.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  Map<String, AnimationController?>? _sectionController;

  final List<Widget> _charts = [
    LineChartSample1(),
    Text("data"),
    Text("data"),
    Text("data")
  ];
  int _currentIndex = 0;
  late double height = MediaQuery.of(context).size.height;
  final List<OverviewTransaction> overview_transaction = [
    OverviewTransaction("income", currency: "\$", value: 5000),
    OverviewTransaction("expense", currency: "\$", value: 3000)
  ];

  bool hasFilter = false;
  bool isExpandAll = false;

  @override
  void initState() {
    super.initState();
    _sectionController = {};
  }

  @override
  void dispose() {
    _sectionController?.forEach((key, value) {
      value?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 26),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropDown<String>(
                isExpanded: false,
                hint: "Time",
                items: ["1", "2"],
                choseValue: null,
                onChanged: (p0) => null,
              ).builder(),
              IconButton(
                  onPressed: () async => showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Filter Transaction"),
                                    TextButton(
                                        onPressed: null, child: Text("Reset"))
                                  ],
                                ),
                                Text("Fiter by"),
                                Align(
                                  alignment: Alignment.center,
                                  child: Wrap(
                                    spacing: 8.0,
                                    children: List<Widget>.generate(
                                      3,
                                      (int index) {
                                        return ChoiceChip(
                                          label: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text("fsdf"),
                                          ),
                                          //selected: _value == index,
                                          selected: false,
                                          onSelected: (selected) {
                                            // setState(() {
                                            //   _value = selected ? index : null;
                                            // });
                                          },
                                          selectedColor: Colors.white70,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                                Text("Sort by"),
                                Align(
                                  alignment: Alignment.center,
                                  child: Wrap(
                                    spacing: 8.0,
                                    children: List<Widget>.generate(
                                      5,
                                      (int index) {
                                        return ChoiceChip(
                                          label: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text("fsdf"),
                                          ),
                                          //selected: _value == index,
                                          selected: false,
                                          onSelected: (selected) {
                                            // setState(() {
                                            //   _value = selected ? index : null;
                                            // });
                                          },
                                          selectedColor: Colors.white70,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                                Text("Category"),
                                Visibility(
                                    child: Container(
                                  color: Colors.yellow,
                                )),
                              ]),
                        ),
                      ),
                  icon: Icon(Icons.sort,
                      color: hasFilter ? MyColor.purple() : null))
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
                context, RouteApplication.getRoute(ERoute.overviewReport)),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: MyColor.purpleTranparent,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "See your financial report",
                    style: TextStyle(color: MyColor.purple()),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: MyColor.purple(),
                  )
                ],
              ),
            ),
          ),
          StatefulBuilder(
              builder: (context, _setState) => Container(
                    alignment: Alignment.centerRight,
                    width: double.maxFinite,
                    child: TextButton(
                        onPressed: () {
                          _setState(() => isExpandAll = !isExpandAll);
                          if (isExpandAll)
                            _sectionController?.forEach((key, value) {
                              value?.forward();
                            });
                          else
                            _sectionController?.forEach((key, value) {
                              value?.reverse();
                            });
                        },
                        child: Text(isExpandAll ? "Shink all" : "Expand all")),
                  )),
          StreamBuilder<QuerySnapshot<ModalTransactionLog>>(
              initialData: null,
              stream: CurrentTransaction().getStreamTransaction(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  //wait to loading
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.data!.size == 0) {
                    //hasn't transaction yet
                    return Expanded(
                        child: Center(child: Text("Empty list transaction")));
                  } else {
                    return FutureBuilder<
                            SplayTreeMap<String, List<ModalTransaction>?>>(
                        initialData: null,
                        future: filterTransactionByDateTime(snapshot.data!),
                        builder: (context, snapshot) => snapshot.hasData
                            ? Expanded(
                                child: CustomScrollView(
                                    physics: BouncingScrollPhysics(),
                                    slivers:
                                        snapshot.data!.entries.map((group) {
                                      if (group.value!.isNotEmpty) {
                                        if (!_sectionController!
                                            .containsKey(group.key)) {
                                          _sectionController!.addAll({
                                            group.key: AnimationController(
                                                vsync: this,
                                                duration: const Duration(
                                                    milliseconds: 500))
                                          });
                                        }
                                        return Section(
                                            headerColor:
                                                MyColor.mainBackgroundColor,
                                            titleColor: Colors.white,
                                            title:
                                                "${group.key} (${group.value!.length}) transactions",
                                            controller:
                                                _sectionController![group.key],
                                            headerPressable: true,
                                            onPressed: () {
                                              if (_sectionController![
                                                      group.key] !=
                                                  null) {
                                                _sectionController![group.key]!
                                                        .isDismissed
                                                    ? _sectionController![
                                                            group.key]!
                                                        .forward()
                                                    : _sectionController![
                                                            group.key]!
                                                        .reverse();
                                              }
                                            },
                                            content: MediaQuery.removePadding(
                                                context: context,
                                                removeTop: true,
                                                removeBottom: snapshot
                                                        .data!.entries.last !=
                                                    group,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: group.value!
                                                      .map((modal) => Column(
                                                            children: [
                                                              TransactionComponent(
                                                                parentController:
                                                                    _sectionController![
                                                                        group
                                                                            .key],
                                                                modal: modal,
                                                                isEditable:
                                                                    true,
                                                                onTap:
                                                                    () async {
                                                                  await Navigator.pushNamed(
                                                                      context,
                                                                      RouteApplication.getRoute(
                                                                          ERoute.detailTransaction),
                                                                      arguments: [
                                                                        modal,
                                                                        true,
                                                                        false
                                                                      ]);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                editSlidableAction:
                                                                    (context) async {
                                                                  // await Navigator.pushNamed(
                                                                  //     context,
                                                                  //     RouteApplication
                                                                  //         .getRoute(ERoute
                                                                  //             .addEditTransaction),
                                                                  //     arguments: modal);
                                                                  // setState(() {});
                                                                },
                                                                deleteSlidableAction:
                                                                    (context) {
                                                                  // Future.delayed(
                                                                  //     const Duration(
                                                                  //         milliseconds:
                                                                  //             500),
                                                                  //     () => DataSample
                                                                  //             .instance()
                                                                  //         .removeTransaction(
                                                                  //             modal));
                                                                },
                                                              ),
                                                            ],
                                                          ))
                                                      .toList(),
                                                ))).builder();
                                      } else {
                                        return const SliverPadding(
                                            padding: EdgeInsets.all(0));
                                      }
                                    }).toList()))
                            : LinearProgressIndicator());
                  }
                }
              })
        ],
      ),
    );
  }

  String _getDate(DateTime date) =>
      "${date.year}-${date.month >= 10 ? date.month : "0${date.month}"}-${date.day >= 10 ? date.day : "0${date.day}"}";

  Future<Map<ModalTransaction, ModalTransaction?>> mappingCompareTimeCreate(
      Map<String, List<ModalTransaction>?> data) async {
    Map<ModalTransaction, ModalTransaction?> map = {};
    for (List<ModalTransaction>? modal in data.values) {
      if (modal != null) {
        for (ModalTransaction element in modal) {
          map.addAll({element: null});
        }
      }
    }
    CurrentTransaction service = CurrentTransaction();
    for (ModalTransaction modal in map.keys) {
      map[modal] = await service.findFirstTransaction(modal);
    }

    return map;
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>>
      filterTransactionByDateTime(
          QuerySnapshot<ModalTransactionLog> querySnapshot) async {
    TransactionFirestore serviceTransaction = TransactionFirestore();

    Map<String, List<ModalTransaction>?> result =
        <String, List<ModalTransaction>?>{};

    Iterable<ModalTransactionLog?> iterable =
        querySnapshot.docs.map<ModalTransactionLog?>((e) => e.data());

    //fliter day to group
    for (ModalTransactionLog? element in iterable) {
      ModalTransaction? currerntModal = element!.lastTransactionRef == null
          ? null
          : await serviceTransaction
              .getModalFromRef(element.lastTransactionRef!);
      ModalTransaction? firstModal = await serviceTransaction
          .getModalFromRef(element.firstTransactionRef!);
      ModalTransaction push = currerntModal ?? firstModal!;
      String key = _getDate(firstModal!.timeCreate!);
      if (result.containsKey(key)) {
        result[key]!.add(push);
      } else {
        result.addAll({
          key: [push]
        });
      }
    }

    //get first modal (not modified yet)
    Map<ModalTransaction, ModalTransaction?> mapCompare =
        await mappingCompareTimeCreate(result);

    //sort group by timeCreate
    for (String element in result.keys) {
      result[element]!.sort((modal1, modal2) {
        ModalTransaction? compare1 = mapCompare[modal1];
        ModalTransaction? compare2 = mapCompare[modal2];
        return compare1!.timeCreate!.compareTo(compare2!.timeCreate!);
      });
    }

    return SplayTreeMap<String, List<ModalTransaction>?>.from(result,
        (key1, key2) => DateTime.parse(key1).compareTo(DateTime.parse(key2)));
  }

  @override
  bool get wantKeepAlive => true;
}
