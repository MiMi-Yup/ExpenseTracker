import 'package:expense_tracker/instances/transaction_type_instance.dart';
import 'package:expense_tracker/modals/modal_transaction.dart';
import 'package:expense_tracker/widgets/component/transaction_component.dart';
import 'package:expense_tracker/widgets/timelines/timelines.dart';
import 'package:flutter/material.dart';

class TimelineModiedTransaction extends StatelessWidget {
  TimelineModiedTransaction({Key? key, required this.timelineModiedTransaction})
      : super(key: key) {
    timelineModiedTransaction.add(timelineModiedTransaction.last);
  }

  final List<ModalTransaction> timelineModiedTransaction;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: timelineModiedTransaction.length,
            contentsBuilder: (_, index) {
              if (index == timelineModiedTransaction.length - 1) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${timelineModiedTransaction[index].getDateTransaction} ${timelineModiedTransaction[index].getFullTimeTransaction}',
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18.0,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TransactionComponent(
                          modal: timelineModiedTransaction[index],
                          isEditable: false),
                    )
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (identical(timelineModiedTransaction[index],
                  timelineModiedTransaction.first)) {
                return DotIndicator(
                  color: TranasactionTypeInstance.instance()
                      .getModal(timelineModiedTransaction
                          .first.transactionTypeRef!.id)
                      ?.color,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                    borderWidth: 2.5,
                    color: TranasactionTypeInstance.instance()
                        .getModal(timelineModiedTransaction[index]
                            .transactionTypeRef!
                            .id)
                        ?.color);
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: TranasactionTypeInstance.instance()
                  .getModal(
                      timelineModiedTransaction[index].transactionTypeRef!.id)
                  ?.color,
            ),
          ),
        ),
      ),
    );
  }
}
