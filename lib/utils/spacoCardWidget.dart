import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

spacoCard(color, title, subtitle, icon, onPressed) {
  return GestureDetector(
    onTap: () {
      Get.to(onPressed);
    },
    child: Container(
      width: Get.height * 0.4,
      height: Get.width,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                  width: Get.width * 0.05,
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
