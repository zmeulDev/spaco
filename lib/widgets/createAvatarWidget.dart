import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/utils/constant.dart';

createAvatarWidget(double radius) {
  String tempUserImg = 'assets/user.png';

  return AvatarView(
    radius: radius,
    borderColor: secondaryColor,
    avatarType: AvatarType.CIRCLE,
    backgroundColor: primaryColor,
    imagePath:
        UserModel().profileUrl == '' ? tempUserImg : UserModel().profileUrl,
    placeHolder: Container(
      color: secondaryColor,
      child: Icon(
        Iconsax.user,
        size: 36,
      ),
    ),
    errorWidget: Container(
      color: fourthColor,
      child: Icon(
        Iconsax.user1,
        size: 36,
      ),
    ),
  );
}
