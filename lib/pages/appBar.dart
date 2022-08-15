// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spaco/pages/Profile/profile.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/utils/constant.dart';

getAppBar(String screenName, context) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Get.to(() => const Home());
      },
      icon: Image.asset(
        'assets/logo/spaco_logo_black_512.png',
        height: Get.height * 0.030,
        fit: BoxFit.contain,
      ),
    ),
    backgroundColor: scaffoldColor,
    automaticallyImplyLeading: true,
    elevation: 0.0,
    centerTitle: true,
    title: Text(
      screenName,
      style: style2.copyWith(color: primaryColor, fontSize: Get.height * 0.030),
    ),
    actions: [
      IconButton(
        onPressed: () {
          Get.to(() => const Profile());
        },
        icon: Icon(
          CupertinoIcons.person,
          size: Get.height * 0.030,
          color: primaryColor,
        ),
      ),
    ],
  );
}
