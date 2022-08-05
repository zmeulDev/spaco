import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spaco/utils/constant.dart';

Widget spacoLoading() {
  return SpinKitFadingFour(
    size: 30.0,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? tertiaryColor : fourthColor,
        ),
      );
    },
  );
}
