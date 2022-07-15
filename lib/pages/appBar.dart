import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:spaco/pages/Profile/profile.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/utils/constant.dart';

getAppBar(String screenName, context) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Get.to(() => Home());
      },
      icon: Icon(
        FeatherIcons.coffee,
        color: primaryColor,
      ),
    ),
    backgroundColor: scaffoldColor,
    automaticallyImplyLeading: true,
    elevation: 0.0,
    centerTitle: true,
    title: Text(
      screenName,
      style: style2.copyWith(color: primaryColor),
    ),
    actions: [
      IconButton(
        onPressed: () {
          Get.to(() => Profile());
        },
        icon: Icon(FeatherIcons.user),
      ),
    ],
  );
}
