import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:spaco/models/partner_model.dart';
import 'package:spaco/utils/constant.dart';

createPartnerWidget(double radius) {
  return AvatarView(
    radius: radius,
    borderColor: tertiaryColor,
    avatarType: AvatarType.RECTANGLE,
    backgroundColor: secondaryColor,
    imagePath: PartnerModel().partnerProfile,
    placeHolder: Container(
      color: fourthColor,
      child: const Icon(
        CupertinoIcons.alarm_fill,
        size: 36,
        color: tertiaryColor,
      ),
    ),
    errorWidget: Container(
      color: fourthColor,
      child: const Icon(
        CupertinoIcons.alarm,
        size: 36,
      ),
    ),
  );
}
