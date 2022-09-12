import 'package:expense_tracker/modals/modal_category_type.dart';
import 'package:expense_tracker/services/firebase/cloud_storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HintCategoryComponent {
  ModalCategoryType modal;
  HintCategoryComponent({required this.modal});

  Widget getFullCategory({double height = 50.0}) => Container(
        width: height,
        height: height,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: modal.color?.withAlpha(25)),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: modal.localAsset == true
              ? Image.asset(
                  modal.image!,
                  color: modal.color,
                )
              : FutureBuilder<Uint8List?>(
                  future: ActionFirebaseStorage.downloadFile(modal.image!),
                  builder: (context, snapshot) => snapshot.hasData
                      ? Image.memory(snapshot.data!)
                      : Text("Wait")),
        ),
      );

  Widget getMinCategory(
          {double height = 10.0,
          Color? indicatorColor,
          Color? backgroundColor}) =>
      Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height * 2),
            border: Border.all(color: modal.color!.withAlpha(150))),
        child: Row(
          children: [
            Container(
              height: height,
              width: height,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                  color: indicatorColor ?? modal.color, shape: BoxShape.circle),
            ),
            Text(modal.name!)
          ],
        ),
      );
}
