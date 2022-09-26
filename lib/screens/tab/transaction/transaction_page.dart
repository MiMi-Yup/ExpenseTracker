import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/modals/modal.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/fliter_month_component.dart';
import 'package:expense_tracker/widgets/component/hint_category_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/dropdown.dart';
import 'package:expense_tracker/widgets/month_picker.dart';
import 'package:expense_tracker/widgets/overview_transaction.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:expense_tracker/widgets/transaction_chart.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

enum SortBy { money, time }

enum SortOrder { descending, ascending }

class _TransactionPageState extends State<TransactionPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  Map<String, AnimationController?>? _sectionController;

  final TransactionUtilities serviceTransaction = TransactionUtilities();
  final CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();

  late double height = MediaQuery.of(context).size.height;

  bool hasFilter = false;
  bool isExpandAll = false;

  bool keepAlive = true;

  DateTime? fliterTransactionByMonth;
  ModalCategoryType? selectedFilterCategory;
  ModalTransactionType? selectedFilterTransactionType;
  SortBy? sortBy;
  SortOrder sortOrder = SortOrder.descending;

  final Map<SortOrder, Color> mapSortOrder = {
    SortOrder.descending: Colors.green,
    SortOrder.ascending: Colors.red
  };

  Stream<QuerySnapshot<ModalTransactionLog>>? _streamLog;

  @override
  void initState() {
    super.initState();
    _sectionController = {};
    _streamLog = serviceLog.stream;
  }

  @override
  void dispose() {
    _sectionController?.forEach((key, value) {
      value?.dispose();
    });
    _streamLog = null;
    super.dispose();
  }

  Widget getModalChip(
          {required String name,
          required Color indicatorColor,
          double height = 10.0,
          Color? backgroundColor}) =>
      Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height * 2),
            border: Border.all(color: indicatorColor.withAlpha(150))),
        child: Row(
          children: [
            Container(
              height: height,
              width: height,
              margin: EdgeInsets.only(right: 10.0),
              decoration:
                  BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
            ),
            Text(name)
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 26),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterTransactionByMonthComponent(
                      onChanged: (value) {
                        RouteApplication.navigatorKey.currentState?.pop();
                        setState(() {
                          fliterTransactionByMonth = value;
                        });
                      },
                      setInitDateTime: fliterTransactionByMonth == null
                          ? (value) => WidgetsBinding.instance
                              .addPostFrameCallback((_) => setState(
                                  () => fliterTransactionByMonth = value))
                          : null,
                      selectedDate: fliterTransactionByMonth)
                  .builder(),
              IconButton(
                  onPressed: () async {
                    await showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setState) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Filter Transaction"),
                                              TextButton(
                                                  onPressed: () {
                                                    sortBy = null;
                                                    selectedFilterCategory =
                                                        null;
                                                    selectedFilterTransactionType =
                                                        null;
                                                    sortOrder =
                                                        SortOrder.descending;
                                                    setState(() {});
                                                  },
                                                  child: Text("Reset"))
                                            ],
                                          ),
                                          Text("Fiter by"),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.count(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 8.0,
                                              crossAxisSpacing: 8.0,
                                              childAspectRatio: 3,
                                              shrinkWrap: true,
                                              children: CategoryInstance
                                                      .instance()
                                                  .modals!
                                                  .map<Widget>((e) {
                                                ModalCategoryType? modal =
                                                    CategoryInstance.instance()
                                                        .getModal(e!.id!);
                                                return GestureDetector(
                                                  onTap: () {
                                                    selectedFilterCategory =
                                                        selectedFilterCategory !=
                                                                e
                                                            ? e
                                                            : null;
                                                    setState(() {});
                                                  },
                                                  child: modal == null
                                                      ? null
                                                      : HintCategoryComponent(
                                                              modal: modal)
                                                          .getMinCategory(
                                                              backgroundColor:
                                                                  selectedFilterCategory ==
                                                                          e
                                                                      ? Color.fromARGB(
                                                                          255,
                                                                          93,
                                                                          0,
                                                                          255)
                                                                      : null),
                                                );
                                              }).toList()
                                                ..addAll(
                                                    TranasactionTypeInstance
                                                            .instance()
                                                        .modals!
                                                        .map<Widget>((e) =>
                                                            GestureDetector(
                                                              onTap: () {
                                                                selectedFilterTransactionType =
                                                                    selectedFilterTransactionType !=
                                                                            e
                                                                        ? e
                                                                        : null;
                                                                setState(() {});
                                                              },
                                                              child: getModalChip(
                                                                  name:
                                                                      e!.name!,
                                                                  indicatorColor:
                                                                      e.color!,
                                                                  backgroundColor: selectedFilterTransactionType ==
                                                                          e
                                                                      ? Color.fromARGB(
                                                                          255,
                                                                          93,
                                                                          0,
                                                                          255)
                                                                      : null),
                                                            ))),
                                            ),
                                          ),
                                          Text("Sort by"),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.count(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 8.0,
                                              crossAxisSpacing: 8.0,
                                              childAspectRatio: 3,
                                              shrinkWrap: true,
                                              children: SortBy.values
                                                  .map<Widget>((e) =>
                                                      GestureDetector(
                                                          onTap: () {
                                                            if (sortBy == e) {
                                                              sortBy = null;
                                                            } else {
                                                              sortBy = e;
                                                            }
                                                            setState(() {});
                                                          },
                                                          child: getModalChip(
                                                              name:
                                                                  '${e.name[0].toUpperCase()}${e.name.substring(1).toLowerCase()}',
                                                              indicatorColor:
                                                                  Colors.grey,
                                                              backgroundColor:
                                                                  sortBy == e
                                                                      ? Color.fromARGB(
                                                                          255,
                                                                          93,
                                                                          0,
                                                                          255)
                                                                      : null)))
                                                  .toList()
                                                ..add(GestureDetector(
                                                  onTap: () => setState(() =>
                                                      sortOrder = sortOrder ==
                                                              SortOrder
                                                                  .ascending
                                                          ? SortOrder.descending
                                                          : SortOrder
                                                              .ascending),
                                                  child: getModalChip(
                                                      name:
                                                          '${sortOrder.name[0].toUpperCase()}${sortOrder.name.substring(1).toLowerCase()}',
                                                      indicatorColor:
                                                          Colors.black,
                                                      backgroundColor:
                                                          mapSortOrder[
                                                              sortOrder]),
                                                )),
                                            ),
                                          ),
                                          Text("Category"),
                                          Visibility(
                                              child: Container(
                                            color: Colors.yellow,
                                          )),
                                        ]),
                                  ));
                        });

                    setState(() {});
                  },
                  icon: Icon(Icons.sort,
                      color: hasFilter ? MyColor.purple() : null))
            ],
          ),
          GestureDetector(
            onTap: () => RouteApplication.navigatorKey.currentState
                ?.pushNamed(RouteApplication.getRoute(ERoute.overviewReport)),
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
              stream: _streamLog,
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
                        future: filterTransaction(snapshot.data!),
                        builder: (context, snapshot) => snapshot.hasData
                            ? snapshot.data!.isNotEmpty
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
                                                controller: _sectionController![
                                                    group.key],
                                                headerPressable: true,
                                                onPressed: () {
                                                  if (_sectionController![
                                                          group.key] !=
                                                      null) {
                                                    _sectionController![
                                                                group.key]!
                                                            .isDismissed
                                                        ? _sectionController![
                                                                group.key]!
                                                            .forward()
                                                        : _sectionController![
                                                                group.key]!
                                                            .reverse();
                                                  }
                                                },
                                                content:
                                                    MediaQuery.removePadding(
                                                        context: context,
                                                        removeTop: true,
                                                        removeBottom: snapshot
                                                                .data!
                                                                .entries
                                                                .last !=
                                                            group,
                                                        child: ListView(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          children: group.value!
                                                              .map(
                                                                (modal) =>
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
                                                                    await RouteApplication
                                                                        .navigatorKey
                                                                        .currentState
                                                                        ?.pushNamed(
                                                                            RouteApplication.getRoute(ERoute.detailTransaction),
                                                                            arguments: [
                                                                          modal,
                                                                          true,
                                                                          false
                                                                        ]);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  editSlidableAction:
                                                                      (context) {
                                                                    RouteApplication
                                                                        .navigatorKey
                                                                        .currentState
                                                                        ?.pushNamed(
                                                                            RouteApplication.getRoute(ERoute
                                                                                .addEditTransaction),
                                                                            arguments:
                                                                                modal);
                                                                  },
                                                                  deleteSlidableAction:
                                                                      (context) async {
                                                                    await serviceTransaction
                                                                        .delete(
                                                                            modal);
                                                                  },
                                                                ),
                                                              )
                                                              .toList(),
                                                        ))).builder();
                                          } else {
                                            return const SliverPadding(
                                                padding: EdgeInsets.all(0));
                                          }
                                        }).toList()))
                                : Expanded(
                                    child: Center(
                                        child: Text(
                                            "No transaction in this month!")))
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

    for (ModalTransaction modal in map.keys) {
      map[modal] = await serviceLog.findFirstTransaction(modal);
    }

    return map;
  }

  bool acceptPushTransaction(ModalTransaction modal) {
    if ((selectedFilterCategory == null
            ? true
            : selectedFilterCategory?.id == modal.categoryTypeRef?.id) &&
        (selectedFilterTransactionType == null
            ? true
            : selectedFilterTransactionType?.id ==
                modal.transactionTypeRef?.id)) return true;

    return false;
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>> sortByTime(
    Map<String, List<ModalTransaction>?> result,
  ) async {
    //get first modal (not modified yet)
    Map<ModalTransaction, ModalTransaction?> mapCompare =
        await mappingCompareTimeCreate(result);

    //sort each group by timeCreate
    for (String element in result.keys) {
      result[element]!.sort((modal1, modal2) {
        ModalTransaction? compare1 = sortOrder == SortOrder.ascending
            ? mapCompare[modal1]
            : mapCompare[modal2];
        ModalTransaction? compare2 = sortOrder == SortOrder.ascending
            ? mapCompare[modal2]
            : mapCompare[modal1];
        return compare1!.timeCreate!.compareTo(compare2!.timeCreate!);
      });
    }

    //sort key of group
    return SplayTreeMap<String, List<ModalTransaction>?>.from(
        result,
        (key1, key2) =>
            DateTime.parse(sortOrder == SortOrder.ascending ? key1 : key2)
                .compareTo(DateTime.parse(
                    sortOrder == SortOrder.ascending ? key2 : key1)));
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>> sortByMoney(
      Map<String, List<ModalTransaction>?> result) async {
    for (String element in result.keys) {
      result[element]!.sort((modal1, modal2) =>
          ((sortOrder == SortOrder.ascending ? modal1 : modal2).money! -
                  (sortOrder == SortOrder.ascending ? modal2 : modal1).money!)
              .toInt());
    }

    return SplayTreeMap<String, List<ModalTransaction>?>.from(
        result,
        (key1, key2) =>
            DateTime.parse(sortOrder == SortOrder.ascending ? key1 : key2)
                .compareTo(DateTime.parse(
                    sortOrder == SortOrder.ascending ? key2 : key1)));
  }

  Future<SplayTreeMap<String, List<ModalTransaction>?>> filterTransaction(
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
      ModalTransaction? push = currerntModal ?? firstModal;

      if (push != null &&
          firstModal?.getTimeCreate?.year == fliterTransactionByMonth?.year &&
          firstModal?.getTimeCreate?.month == fliterTransactionByMonth?.month &&
          acceptPushTransaction(push)) {
        String key = _getDate(firstModal!.getTimeCreate!);
        if (result.containsKey(key)) {
          result[key]!.add(push);
        } else {
          result.addAll({
            key: [push]
          });
        }
      }
    }

    switch (sortBy) {
      case SortBy.time:
        return sortByTime(result);
      case SortBy.money:
        return sortByMoney(result);
      default:
        return sortByTime(result);
    }
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
