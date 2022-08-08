import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:spaco/models/partner_model.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/spacoLoading.dart';

createPartnerWidget(double radius) {
  String tempUserImg = 'assets/logo/spaco_logo_green_512.png';

  return AvatarView(
    radius: radius,
    borderColor: secondaryColor,
    avatarType: AvatarType.RECTANGLE,
    backgroundColor: primaryColor,
    imagePath: PartnerModel().partnerProfile == ''
        ? tempUserImg
        : PartnerModel().partnerProfile,
    placeHolder: Container(
      color: secondaryColor,
      child: spacoLoading(),
    ),
    errorWidget: Container(
      color: fourthColor,
      child: const Icon(
        CupertinoIcons.arrow_left_right_circle,
        size: 36,
      ),
    ),
  );
}
