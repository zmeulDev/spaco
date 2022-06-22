import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';
import 'package:spaco/widgets/createPartnerWidget.dart';

File? _image;

Widget displayImage(String widgetType) {
  if (_image == '' || _image == null) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: secondaryColor,
      ),
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
