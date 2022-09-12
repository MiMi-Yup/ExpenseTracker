import 'package:expense_tracker/instances/category_instance.dart';
import 'package:expense_tracker/instances/user_instance.dart';
import 'package:expense_tracker/modals/modal_budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BudgetComponent extends StatefulWidget {
  ModalBudget modal;
  double nowMoney;

  void Function()? onTap;
  void Function(BuildContext)? editSlidableAction;
  void Function(BuildContext)? deleteSlidableAction;
  Color backgroundIndicatorColor;
  Color indicatorColor;
  Color valueColor;

  BudgetComponent({
    super.key,
    required this.modal,
    required this.nowMoney,
    this.onTap,
    this.editSlidableAction,
    this.deleteSlidableAction,
    this.backgroundIndicatorColor = Colors.grey,
    this.indicatorColor = Colors.orange,
    this.valueColor = Colors.red,
  });

  @override
  State<BudgetComponent> createState() => _BudgetComponentState();
}

class _BudgetComponentState extends State<BudgetComponent>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller ??= AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        reverseDuration: const Duration(seconds: 0));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BudgetComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controller!.isDismissed) {
      _controller?.reverse();
    }
  }

  final double height = 10.0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizeTransition(
        sizeFactor: ReverseAnimation(CurvedAnimation(
          curve: Curves.linear,
          parent: _controller!,
        )),
        child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
                margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                            // An action can be bigger than the others.
                            onPressed: widget.editSlidableAction,
                            backgroundColor: Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        SlidableAction(
                            onPressed: (context) async {
                              await _controller!.forward();
                              if (widget.deleteSlidableAction != null) {
                                widget.deleteSlidableAction!(context);
                              }
                            },
                            backgroundColor: Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.delete_forever,
                            label: 'Delete',
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CategoryInstance.instance()
                                  .getHintCategoryComponent(
                                      widget.modal.categoryTypeRef!.id)
                                  .getMinCategory(),
                              Visibility(
                                child: Icon(
                                  Icons.warning_amber,
                                  color: Colors.red,
                                ),
                                visible: widget.modal.isAlert(widget.nowMoney),
                              )
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Text(
                              "Remaining ${UserInstance.instance().getCurrency().currencyCode} ${widget.modal.remainMoney(widget.nowMoney)}"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: width,
                                  height: height,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(height * 2),
                                      color: widget.backgroundIndicatorColor),
                                ),
                                Container(
                                  width: width * widget.modal.percent,
                                  height: height,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(height * 2),
                                      color: widget.indicatorColor),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "${UserInstance.instance().getCurrency().currencyCode} ${widget.nowMoney} of ${UserInstance.instance().getCurrency().currencyCode} ${widget.modal.budget}",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 10.0),
                          Visibility(
                              visible:
                                  widget.modal.isExceedLimit(widget.nowMoney),
                              child: Text(
                                "You're exceed the limit!",
                                style: TextStyle(color: Colors.red),
                              ))
                        ],
                      ),
                    )))));
  }
}
