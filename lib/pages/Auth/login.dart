import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:spaco/pages/Auth/enterotp.dart';
import 'package:spaco/utils/constant.dart';

class Login extends StatelessWidget {
  final TextEditingController phoneNoController = TextEditingController();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          children: [
            loginTopHeader(),
            SizedBox(
              height: Get.height * 0.05,
            ),
            loginForm(context),
            loginArrowButton(() {
              if (phoneNoController.text.isEmpty) {
                Get.snackbar('Error', 'Please enter yor phone number.',
                    colorText: secondaryColor,
                    icon: const Icon(
                      FeatherIcons.info,
                      color: secondaryColor,
                    ),
                    backgroundColor: errorColor);
              } else {
                Get.to(() => EnterOTPScreen(phoneNoController.text));
              }
            })
          ],
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  forgetPassword(function) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: function,
          child: Text(
            'Forget Password?',
            style: style3.copyWith(color: secondaryColor),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  loginTopHeader() {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: SvgPicture.asset('assets/svg/phone_login.svg')),
    );
  }

  loginForm(BuildContext context) {
    return Column(
      children: [
        Text(
          'Log in',
          style: style1,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Enter your phone number with country prefix.',
            style: style3,
          ),
        ),
        Container(
          width: Get.width * 0.8,
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: phoneNoController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              labelText: "Phone number",
              floatingLabelStyle:
                  const TextStyle(height: 4, color: primaryColor),
              filled: true,
              fillColor: secondaryColor,
              prefix: const Text('+'),
              prefixIcon: const Icon(
                FeatherIcons.phone,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  loginArrowButton(validate) {
    return Expanded(
      child: SizedBox(
        height: 52,
        width: 62,
        child: Center(
          child: ElevatedButton(
              onPressed: validate,
              style: ElevatedButton.styleFrom(
                  primary: secondaryColor,
                  padding: const EdgeInsets.all(13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: const Icon(
                CupertinoIcons.arrow_right,
                size: 30,
                color: primaryColor,
              )),
        ),
      ),
    );
  }
}
