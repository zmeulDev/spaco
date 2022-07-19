import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';

Widget spacoInput(hintText, labelText, keyboardType, suffixIcon,
    TextEditingController controller) {
  return Container(
    margin: EdgeInsets.all(5),
    child: TextField(
      controller: controller,
      cursorColor: secondaryColor,
      cursorHeight: 20,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: style3.copyWith(color: secondaryColor.withOpacity(0.3)),
        labelText: labelText,
        labelStyle: style3,
        contentPadding: EdgeInsets.all(8),
        suffixIcon: Icon(
          suffixIcon,
          color: secondaryColor,
          size: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            color: secondaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
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
