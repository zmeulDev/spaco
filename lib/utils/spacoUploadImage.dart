import 'package:flutter/material.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';
import 'package:spaco/widgets/createPartnerWidget.dart';

Widget spacoUploadImage(String widgetType, image) {
  if (image == '' || image == null) {
    return Container(
      child: widgetType == 'profile'
          ? createAvatarWidget(75)
          : createPartnerWidget(12),
    );
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        image!,
        fit: BoxFit.cover,
      ),
    );
  }
}
