import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:spaco/models/partner_model.dart';
import 'package:spaco/utils/constant.dart';

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
      child: Icon(
        FeatherIcons.alertOctagon,
        size: 36,
      ),
    ),
    errorWidget: Container(
      color: fourthColor,
      child: Icon(
        FeatherIcons.anchor,
        size: 36,
      ),
    ),
  );
}
