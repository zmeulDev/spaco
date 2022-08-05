import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:spaco/pages/Auth/login.dart';
import 'package:spaco/utils/constant.dart';

class ChooseLoginSignup extends StatelessWidget {
  const ChooseLoginSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: Get.height * 0.5,
                  width: Get.width,
                  color: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo/spaco_logo_white_512.png',
                          height: Get.height * 0.16, fit: BoxFit.contain),
                      SizedBox(height: Get.height * 0.05),
                      Text(
                        'spaco',
                        style: style1.copyWith(
                            fontSize: 28, color: secondaryColor),
                      ),
                      Text(
                        'co-space management',
                        style: style2.copyWith(color: secondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => Login());
                    },
                    child: Container(
                      height: Get.height * 0.07,
                      width: Get.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor,
                        //border: Border.all(color: tertiaryColor),
                      ),
                      child: Center(
                          child: Text(
                        'Log in / Sign Up',
                        style: style2.copyWith(color: secondaryColor),
                      )),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
