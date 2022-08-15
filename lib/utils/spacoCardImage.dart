// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

spacoCardImage(networkImage) {
  return Container(
    margin: const EdgeInsets.all(3),
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      alignment: Alignment.center,
      child: Container(
        width: Get.width * 0.4,
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: networkImage != ''
              ? DecorationImage(
                  image: CachedNetworkImageProvider(networkImage),
                  fit: BoxFit.cover)
              : const DecorationImage(
                  image: AssetImage('assets/logo/spaco_logo_green_512.png'),
                  fit: BoxFit.fitHeight,
                ),
        ),
      ),
    ),
  );
}
