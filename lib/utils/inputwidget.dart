import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';

Widget spacoInput(hintText, labelText, keyboardType, suffixIcon,
    TextEditingController controller) {
  return Container(
    child: TextField(
      controller: controller,
      cursorColor: secondaryColor,
      cursorHeight: 20,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: style2,
        labelStyle: style3,
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
            color: Colors.transparent,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            width: 1,
            color: secondaryColor,
          ),
        ),
      ),
      style: style2,
    ),
  );
}
