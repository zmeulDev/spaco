import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              upperImage(context),
              SizedBox(height: 25,),
              loginForm(context),
              loginArrowButton(() {
                if (phoneNoController.text.isEmpty) {
                  Get.snackbar('Error', 'Please enter yor phone number.');
                } else {
                  Get.to(() => EnterOTPScreen(phoneNoController.text));
                }
              })
            ],
          ),
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

  upperImage(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Image(
      image: AssetImage('assets/profile_4.png'),
      fit: BoxFit.cover,
        ),
      ),
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
