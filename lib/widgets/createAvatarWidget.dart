import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/utils/constant.dart';

createAvatarWidget(double radius) {
  return AvatarView(
    radius: radius,
    borderColor: secondaryColor,
    avatarType: AvatarType.RECTANGLE,
    backgroundColor: primaryColor,
    imagePath: UserModel().profileUrl,
    placeHolder: Container(
      color: secondaryColor,
      child: Image.asset('assets/logo/spaco_logo_green_512.png'),
    ),
    errorWidget: Container(
      color: fourthColor,
      child: Image.asset('assets/logo/spaco_logo_green_512.png'),
    ),
  );
}
