import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/pages/Auth/login.dart';
import 'package:spaco/utils/constant.dart';

class ChooseLoginSignup extends StatelessWidget {
  const ChooseLoginSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: secondaryColor,
              child: ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: height * 0.5,
                  width: width,
                  color: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.hierarchy_square,
                        color: secondaryColor,
                        size: 128,
                      ),
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
                      height: height * 0.07,
                      width: width * 0.5,
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
