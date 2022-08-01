import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';
import 'package:spaco/widgets/createPartnerWidget.dart';

Widget displayImage(String widgetType, _image) {
  if (_image == '' || _image == null) {
    return Container(
      child: widgetType == 'profile'
          ? createAvatarWidget(75)
          : createPartnerWidget(75),
    );
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.circular(75),
      child: Image.file(
        _image!,
        fit: BoxFit.cover,
      ),
    );
  }
}
