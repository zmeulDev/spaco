import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

double height = Get.height;
double width = Get.width;

spacoCard(color, title, subtitle, icon, onPressed) {
  return GestureDetector(
    onTap: () {
      Get.to(onPressed);
    },
    child: Container(
      width: width * 0.4,
      height: height,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: primaryColor,
                  size: 26,
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: style3.copyWith(color: primaryColor)),
                    Text(subtitle, style: style3.copyWith(color: primaryColor)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
