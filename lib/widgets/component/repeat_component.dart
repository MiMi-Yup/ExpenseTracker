import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modals/modal_frequency_type.dart';
import 'package:expense_tracker/services/firebase/firestore/frequency_types.dart';
import 'package:flutter/material.dart';

class RepeatComponent extends StatelessWidget {
  Map<String, dynamic>? map;
  RepeatComponent({super.key, required this.map});

  Widget _frequencyRepeat(
      {required String title,
      String? subTitle,
      Color? colorTitle,
      Color? colorSubTitle}) {
    List<Widget> items = [
      Text(
        title,
        style: TextStyle(color: colorTitle),
      )
    ];
    if (subTitle != null) {
      items.addAll([
        SizedBox(height: 4.0),
        Text(
          subTitle,
          style: TextStyle(color: colorSubTitle),
        )
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  String _convertTimeStamp(Timestamp? time) {
    DateTime? convert = time?.toDate();
    if (convert != null) {
      return '${convert.year}/${convert.month}/${convert.day} ${_convertTime(TimeOfDay(hour: convert.hour, minute: convert.minute))}';
    }
    return '';
  }

  String _convertTime(TimeOfDay? time) {
    if (time != null) {
      int hour = time.hour;
      int minute = time.minute;
      bool isPM = hour >= 12;
      hour = hour > 12 ? hour - 12 : hour;

      return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute} ${isPM ? "PM" : "AM"}";
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      FutureBuilder<ModalFrequencyType?>(
        future: FrequencyTypesFirestore()
            .getModalFromRef(map?['frequency_type_ref']),
        builder: (context, snapshot) =>
            _frequencyRepeat(title: "Frequency", subTitle: snapshot.data?.name),
      ),
      SizedBox(
        width: 24.0,
      ),
      _frequencyRepeat(
          title: "End after", subTitle: _convertTimeStamp(map?['end_after'])),
    ]);
  }
}
