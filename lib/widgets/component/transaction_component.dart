import 'dart:developer';

import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/instances/category_component.dart';
import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/modals/modal_transaction_type.dart';
import 'package:expense_tracker/services/firebase/firestore/category_types.dart';
import 'package:expense_tracker/services/firebase/firestore/transaction_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionComponent extends StatefulWidget {
  ModalTransaction modal;
  bool isEditable;
  AnimationController? parentController;
  void Function()? onTap;
  void Function(BuildContext)? editSlidableAction;
  void Function(BuildContext)? deleteSlidableAction;
  TransactionComponent(
      {Key? key,
      required this.modal,
      required this.isEditable,
      this.parentController,
      this.onTap,
      this.editSlidableAction,
      this.deleteSlidableAction})
      : super(key: key);

  @override
  State<TransactionComponent> createState() => _TransactionComponentState();
}

class _TransactionComponentState extends State<TransactionComponent>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
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
  void didUpdateWidget(TransactionComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controller!.isDismissed) {
      _controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            // CategoryInstance.instances[widget.modal.category]!()
            //     .getFullCategory(height: 50.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<ModalCategoryType?>(
                      future: CategoryTypeFirebase()
                          .getModalFromRef(widget.modal.categoryTypeRef!),
                      builder: (context, snapshot) => Text(
                          '${snapshot.hasData ? snapshot.data!.name : ''}',
                          style: TextStyle(color: Colors.white))),
                  SizedBox(height: 10.0),
                  Text(
                    widget.modal.description ?? "",
                    style: TextStyle(color: Colors.white70),
                  )
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FutureBuilder<ModalTransactionType?>(
                future: TransactionTypeFirestore()
                    .getModalFromRef(widget.modal.transactionTypeRef!),
                builder: (context, snapshot) => Text(
                      widget.modal.getMoney('\$'),
                      style: TextStyle(
                          color: snapshot.hasData
                              ? snapshot.data?.color
                              : Colors.white),
                    )),
            SizedBox(height: 10.0),
            Text(
              widget.modal.getTimeTransaction,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ]),
    );
    final slidable = SizeTransition(
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
              child: widget.isEditable
                  ? Slidable(
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
                                if (widget.deleteSlidableAction != null)
                                  widget.deleteSlidableAction!(context);
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
                      child: content,
                    )
                  : content)),
    );
    return widget.parentController == null
        ? slidable
        : SizeTransition(
            sizeFactor: CurvedAnimation(
              curve: Curves.linear,
              parent: widget.parentController!,
            ),
            child: slidable,
          );
  }
}
