import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';

Widget spacoInput(hintText, labelText, keyboardType, suffixIcon,
    TextEditingController controller) {
  return Container(
    child: TextField(
      controller: controller,
      cursorColor: sixthColor,
      cursorHeight: 20,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: style2.copyWith(color: sixthColor),
        labelStyle: style3.copyWith(color: sixthColor),
        contentPadding: EdgeInsets.only(left: 8, bottom: 12, right: 5, top: 5),
        suffixIcon: Icon(
          suffixIcon,
          color: secondaryColor,
          size: 20,
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            width: 1,
            color: primaryColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: sixthColor,
          ),
        ),
      ),
      style: style2.copyWith(color: secondaryColor),
    ),
  );
}
