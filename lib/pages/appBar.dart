import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';

getAppBar(String screenName) {
  return AppBar(
    leading: IconButton(
      onPressed: () {},
      icon: Icon(
        Iconsax.hierarchy_square,
        color: secondaryColor,
      ),
    ),
    backgroundColor: primaryColor,
    elevation: 0.0,
    centerTitle: true,
    title: Text(
      screenName,
      style: style1,
    ),
    actions: [
      InkWell(
        onTap: () {
          Get.to(Home());
        },
        child: Row(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5, right: 15),
                child: createAvatarWidget(15),
              ),
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    ],
  );
}
