import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

partnerCard(cardPartnerImage, cardPartnerName) {
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
            height: Get.height * 0.08,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: cardPartnerImage == ''
                ? Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/no_file.svg',
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(cardPartnerImage),
                        fit: BoxFit.cover,
                      ),
                    ),
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
                      Expanded(
                        child: AutoSizeText(
                          cardPartnerName,
                          style: style2.copyWith(color: primaryColor),
                          minFontSize: 11,
                          maxLines: 3,
                        ),
                      )
                    ],
                  ),
                ],
              ))
        ],
      ),
    ],
  );
}
