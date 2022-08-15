// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

spaceCard(cardImage, spaceName, spaceEmail, spaceNoPeople, spaceTV,
    spaceAirConditioning) {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            height: Get.height * 0.2,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
              image: cardImage != ''
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(cardImage),
                      fit: BoxFit.cover)
                  : const DecorationImage(
                      image: AssetImage('assets/logo/spaco_logo_green_512.png'),
                      fit: BoxFit.cover),
            ),
          ),
          Container(
              margin:
                  const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        spaceName,
                        style: style2.copyWith(color: primaryColor),
                      ),
                      Text(
                        spaceEmail,
                        style: style3.copyWith(color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: <Widget>[
                          const Icon(
                            FeatherIcons.users,
                            size: 13,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            spaceNoPeople,
                            style: style3.copyWith(color: primaryColor),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            FeatherIcons.monitor,
                            size: 13,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            spaceTV,
                            style: style3.copyWith(color: primaryColor),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            FeatherIcons.wind,
                            size: 13,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            spaceAirConditioning,
                            style: style3.copyWith(color: primaryColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    ],
  );
}
