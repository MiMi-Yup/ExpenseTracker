import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/category_type_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/screens/tab/filter_transaction.dart';
import 'package:expense_tracker/screens/tab/nav.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/fliter_month_component.dart';
import 'package:expense_tracker/widgets/component/hint_category_component.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/section.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  Map<String, AnimationController?>? _sectionController;

  final TransactionUtilities serviceTransaction = TransactionUtilities();
  final CurrentTransactionFirestore serviceLog = CurrentTransactionFirestore();
  final FilterTransaction filterTransaction = FilterTransaction();

  late double height = MediaQuery.of(context).size.height;

  bool hasFilter = false;
  bool isExpandAll = false;

  bool keepAlive = true;

  ModalCategoryType? selectedFilterCategory;
  ModalTransactionType? selectedFilterTransactionType;
  SortBy? sortBy;
  SortOrder sortOrder = SortOrder.descending;

  final Map<SortOrder, Color> mapSortOrder = {
    SortOrder.descending: Colors.green,
    SortOrder.ascending: Colors.red
  };

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
                        setState(() => Navigation.setState(context, value));
                      },
                      setInitDateTime: Navigation.filterByDate == null
                          ? (value) => WidgetsBinding.instance
                              .addPostFrameCallback((_) => setState(
                                  () => Navigation.setState(context, value)))
                          : null,
                      selectedDate: Navigation.filterByDate)
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
                                              children: CategoryTypeInstance
                                                      .instance()
                                                  .modals!
                                                  .map<Widget>((e) {
                                                ModalCategoryType? modal =
                                                    CategoryTypeInstance.instance()
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
              stream: serviceLog.stream,
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
                        future: filterTransaction.filterTransaction(
                            querySnapshot: snapshot.data!,
                            sortBy: sortBy,
                            sortOrder: sortOrder,
                            selectedFilterCategory: selectedFilterCategory,
                            selectedFilterTransactionType:
                                selectedFilterTransactionType),
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
                                                                          true
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

  @override
  bool get wantKeepAlive => keepAlive;
}
