import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/pages/Auth/enterotp.dart';
import 'package:spaco/utils/constant.dart';

class Login extends StatelessWidget {
  TextEditingController phoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          child: Column(
            children: [
              upperImage(),
              loginForm(context),
              loginArrowButton(() {
                if (phoneNoController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please enter your phone number!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Get.to(() => EnterOTPScreen(phoneNoController.text));
                }
              })
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
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

  upperImage() {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [
            tertiaryColor.withOpacity(0.3),
            tertiaryColor.withOpacity(0.6),
          ])),
      child: Center(
          child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Image(
          image: AssetImage('assets/profile_4.png'),
          fit: BoxFit.fill,
        ),
      )),
    );
  }

  loginForm(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          Text(
            'Log in',
            style: style1.copyWith(color: secondaryColor),
          ),
          Text(
            'Enter your phone number with country prefix.',
            style: style3.copyWith(color: secondaryColor),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: phoneNoController,
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
                prefix: Text('+'),
                prefixIcon: Icon(
                  Iconsax.mobile,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  loginArrowButton(validate) {
    return Expanded(
      child: Container(
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
