import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

spacoImageCard(networkImage) {
  return Container(
    margin: EdgeInsets.all(3),
    padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: sixthColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      alignment: Alignment.center,
      child: Container(
        width: Get.width * 0.4,
        height: Get.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
              image: NetworkImage(
                networkImage,
              ),
              fit: BoxFit.cover),
        ),
      ),
    ),
  );
}
