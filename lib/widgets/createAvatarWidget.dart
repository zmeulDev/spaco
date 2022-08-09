import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/spacoLoading.dart';

createAvatarWidget(double radius) {
  return AvatarView(
    radius: radius,
    borderColor: secondaryColor,
    avatarType: AvatarType.RECTANGLE,
    backgroundColor: primaryColor,
    imagePath: UserModel().profileUrl,
    placeHolder: spacoLoading(),
    errorWidget: Container(
      color: fourthColor,
      child: const Icon(CupertinoIcons.alarm, size: 36),
    ),
  );
}
