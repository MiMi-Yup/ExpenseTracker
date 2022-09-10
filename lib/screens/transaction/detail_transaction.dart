import 'dart:async';

import 'package:expense_tracker/constants/asset/icon.dart';
import 'package:expense_tracker/constants/enum/enum_route.dart';
import 'package:expense_tracker/instances/account_type_instance.dart';
import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:expense_tracker/services/firebase/firestore/current_transaction.dart';
import 'package:expense_tracker/services/firebase/firestore/utilities/transaction.dart';
import 'package:expense_tracker/widgets/component/repeat_component.dart';
import 'package:expense_tracker/widgets/component/timeline_modified_transaction.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DetailTransaction extends StatefulWidget {
  DetailTransaction({Key? key}) : super(key: key);

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction>
    with TickerProviderStateMixin {
  late List<Object>? arguments =
      ModalRoute.of(context)?.settings.arguments as List<Object>?;
  late ModalTransaction modal = arguments?[0] as ModalTransaction;
  late bool isEditable = (arguments?[1] as bool?) ?? false;
  late bool isShowTimelineModified = arguments?[2] as bool;

  GlobalKey keyAppBar = GlobalKey();
  GlobalKey scrollTimeline = GlobalKey();

  Size sizeAppBar = Size.zero;
  Offset position = Offset.zero;

  AnimationController? _animatedContainer;
  ItemScrollController? _scrollController;

  StreamController<bool>? animateOpacityFloatingActionButton;

  @override
  void initState() {
    super.initState();
    _animatedContainer = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500));
    _scrollController = ItemScrollController();
    animateOpacityFloatingActionButton = StreamController();
    animateOpacityFloatingActionButton?.sink.add(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box =
          keyAppBar.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        sizeAppBar = box.size;
        position = box.localToGlobal(Offset.zero);
      });
    });
  }

  @override
  void dispose() {
    _animatedContainer?.dispose();
    animateOpacityFloatingActionButton?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeTypeContainer = size.height / 10;

    List<Widget> itemListView = [];

    itemListView = [
      Text(
        "Description",
        style: TextStyle(color: Colors.white70),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "${modal.description}",
          maxLines: 5,
          style: TextStyle(fontSize: 18),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      if (modal.attachments != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child:
                  Text("Attachment", style: TextStyle(color: Colors.white70)),
            ),
            Container(
                alignment: Alignment.center,
                height: size.height / 3,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: modal.attachments!
                      .map((e) => FutureBuilder<Uint8List?>(
                          future: ActionFirebaseStorage.downloadFile(e),
                          initialData: null,
                          builder: (context, snapshot) => snapshot.hasData
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.all(size.height * 0.1),
                                  width: size.height / 3,
                                  child: CircularProgressIndicator(),
                                )))
                      .toList(),
                ))
          ],
        ),
      if (modal.repeat != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child:
                  Text('Repeat time', style: TextStyle(color: Colors.white70)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: RepeatComponent(map: modal.repeat),
            ),
          ],
        ),
      if (modal.transactionRef != null || isShowTimelineModified)
        Column(
          children: [
            GestureDetector(
              onTap: () {
                if (_animatedContainer?.isDismissed == true) {
                  _animatedContainer?.forward();
                  _scrollController?.scrollTo(
                      index: itemListView.length - 2,
                      duration: const Duration(milliseconds: 500));
                  animateOpacityFloatingActionButton?.sink.add(true);
                } else {
                  _animatedContainer?.reverse();
                  _scrollController?.scrollTo(
                      index: 0, duration: const Duration(milliseconds: 500));
                  animateOpacityFloatingActionButton?.sink.add(false);
                }
              },
              child: ColoredBox(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transaction history mofied',
                            style: TextStyle(color: Colors.white70)),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                            'Last date: ${modal.getDateTransaction} ${modal.getTimeTransaction}')
                      ],
                    ),
                    Text(
                      'Show all',
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      SizeTransition(
        key: scrollTimeline,
        sizeFactor: CurvedAnimation(
          curve: Curves.linear,
          parent: _animatedContainer!,
        ),
        child: FutureBuilder<List<ModalTransaction>?>(
            future: TransactionUtilities().timelineEditTransaction(modal),
            builder: (context, snapshot) => snapshot.hasData
                ? TimelineModiedTransaction(
                    timelineModiedTransaction: snapshot.data!,
                    indicatorModal: modal,
                  )
                : Container(
                    padding: EdgeInsets.all(size.height * 0.1),
                    width: size.height / 3,
                    child: CircularProgressIndicator(),
                  )),
      )
    ];

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: TranasactionTypeInstance.instance()
              .getModal(modal.transactionTypeRef!.id)
              ?.color,
          leading: IconButton(
              onPressed: () =>
                  RouteApplication.navigatorKey.currentState?.pop(),
              icon: Icon(Icons.arrow_back_ios)),
          title: Text("Detail Transaction"),
          actions: isEditable
              ? [
                  IconButton(
                      onPressed: () async {
                        await RouteApplication.navigatorKey.currentState
                            ?.pushNamed(
                                RouteApplication.getRoute(
                                    ERoute.addEditTransaction),
                                arguments: modal);
                        setState(() {});
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        bool? isRemove;
                        await showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Remove this transaction",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(25.0),
                                        child: Text(
                                          "Are you sure do you wanna remove this transaction?",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: largestButton(
                                                background: Colors.grey,
                                                text: "No",
                                                onPressed: () =>
                                                    RouteApplication
                                                        .navigatorKey
                                                        .currentState
                                                        ?.pop()),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: largestButton(
                                                text: "Yes",
                                                onPressed: () async {
                                                  isRemove =
                                                      await TransactionUtilities()
                                                          .delete(modal);
                                                  RouteApplication
                                                      .navigatorKey.currentState
                                                      ?.pop();
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                        isRemove != null && isRemove == true
                            ? showDialog(
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          IconAsset.success,
                                          scale: 2,
                                        ),
                                        SizedBox(height: 16.0),
                                        Text(
                                            "Transaction has been completely removed")
                                      ],
                                    ),
                                  ),
                                ),
                                context: context,
                              )
                            : null;
                        int count = 0;
                        Future.delayed(const Duration(seconds: 1), () {
                          RouteApplication.navigatorKey.currentState
                              ?.popUntil((_) => count++ == 2);
                        });
                      },
                      icon: Icon(Icons.delete_forever_rounded))
                ]
              : null,
          centerTitle: true,
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: animateOpacityFloatingActionButton?.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.data == true) {
              return AnimatedOpacity(
                opacity: snapshot.data == true ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: FloatingActionButton(
                  onPressed: () {
                    animateOpacityFloatingActionButton?.sink.add(false);
                    _scrollController?.scrollTo(
                        index: 0, duration: const Duration(milliseconds: 500));
                  },
                  child: Icon(Icons.arrow_upward),
                ),
              );
            } else
              return SizedBox();
          },
        ),
        body: Stack(children: [
          Column(
            children: [
              Container(
                key: keyAppBar,
                width: size.width,
                padding: EdgeInsets.only(bottom: 50.0),
                decoration: BoxDecoration(
                    color: TranasactionTypeInstance.instance()
                        .getModal(modal.transactionTypeRef!.id)
                        ?.color,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        modal.getMoney(UserInstance.instance()
                            .getCurrency()
                            .currencyCode!),
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${modal.purpose}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<ModalTransaction?>(
                          future:
                              CurrentTransaction().findFirstTransaction(modal),
                          builder: (context, snapshot) => Text(
                                snapshot.hasData
                                    ? '${snapshot.data!.getDateTransaction} ${snapshot.data!.getTimeTransaction}'
                                    : '',
                                style: TextStyle(color: Colors.white70),
                              )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: sizeTypeContainer / 2 + 10.0, left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      10,
                      (index) => Container(
                            height: 4.0,
                            width: size.width / 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                color: Colors.white),
                          )),
                ),
              ),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16.0),
                  itemCount: itemListView.length,
                  itemBuilder: (context, index) => itemListView[index],
                ),
              ),
            ],
          ),
          Positioned(
            top: sizeAppBar.height - position.dy / 2,
            left: position.dx,
            height: sizeTypeContainer,
            width: sizeAppBar.width,
            child: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(left: 25.0, right: 25.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Type", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                          TranasactionTypeInstance.instance()
                              .getModal(modal.transactionTypeRef!.id)
                              .toString(),
                          style: TextStyle(color: Colors.black))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Category", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                          CategoryInstance.instance()
                              .getModal(modal.categoryTypeRef!.id)
                              .toString(),
                          style: TextStyle(color: Colors.black))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Account", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                          "${AccountTypeInstance.instance().getModal(modal.accountRef!.id)?.name}",
                          style: TextStyle(color: Colors.black))
                    ],
                  )
                ],
              ),
            ),
          )
        ]));
  }
}
