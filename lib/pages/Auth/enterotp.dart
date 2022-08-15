import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spaco/Services/auth_services.dart';
import 'package:spaco/pages/navbar.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/helper.dart';

class EnterOTPScreen extends StatefulWidget {
  final String phoneNumber;

  const EnterOTPScreen(this.phoneNumber);

  @override
  _EnterOTPScreenState createState() => _EnterOTPScreenState();
}

class _EnterOTPScreenState extends State<EnterOTPScreen> {
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  String _verificationCode = "";
  String enteredPin = "";
  bool isLoading = false;
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    _verifyPhone();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  otpTopHeader(),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Text(
                    'Enter OTP',
                    style: style1,
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    'We have send your access code Via SMS for',
                    style: style3,
                  ),
                  Text(
                    'mobile number verification.',
                    style: style3,
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  TweenAnimationBuilder<Duration>(
                      duration: const Duration(minutes: 1),
                      tween: Tween(
                          begin: const Duration(minutes: 1),
                          end: Duration.zero),
                      onEnd: () {
                        print('Please go back and try again.');
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text('Wait for: $minutes:$seconds',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)));
                      }),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 52),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: const TextStyle(
                            color: secondaryColor,
                          ),
                          length: 6,
                          obscureText: false,
                          obscuringCharacter: '•',
                          textStyle: style1,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 5) {
                              return null;
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            borderRadius: BorderRadius.circular(12),
                            borderWidth: 2,
                            fieldWidth: 28,
                            activeFillColor: Colors.transparent,
                            inactiveColor: tertiaryColor,
                            inactiveFillColor: Colors.transparent,
                            selectedColor: tertiaryColor,
                            disabledColor: fourthColor,
                          ),
                          cursorColor: tertiaryColor,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: false,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,

                          onCompleted: (val) {
                            enteredPin = val;
                            print(enteredPin);
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        )),
                  ),
                ],
              ),
            ),
            arrowButton(() async {
              var res = await check();
              if (currentText.length != 6 ||
                  currentText.isEmpty ||
                  res == false) {
                errorController!.add(ErrorAnimationType
                    .shake); // Triggering error shake animation
              } else {}
            }),
            SizedBox(
              height: Get.height * 0.08,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t receive the',
                        style: style2.copyWith(color: tertiaryColor),
                      ),
                      Text(
                        ' OTP?',
                        style: style2.copyWith(
                            color: tertiaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.005,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text('Try again', style: style2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+${widget.phoneNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            setState(() {
              isLoading = true;
            });
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              if (value.user != null) {
                if (value.additionalUserInfo?.isNewUser == true) {
                  await AuthServices.uploadUserDatatoFirestore(
                      uid: value.user!.uid,
                      profileUrl: "",
                      phoneNo: widget.phoneNumber,
                      username: "",
                      email: "");
                  setState(() {
                    isLoading = false;
                  });
                  Helper.toReplacementScreen(context, const NavBar());
                } else if (value.additionalUserInfo?.isNewUser == false) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(value.user?.uid)
                      .get()
                      .then((userData) async {
                    if (userData.exists) {
                      await AuthServices.setCurrentUserToMap(value.user?.uid);
                      setState(() {
                        isLoading = false;
                      });
                      Helper.showSnack(context, "Logged In Successfully");
                      Helper.toReplacementScreen(context, const NavBar());
                    } else {
                      await AuthServices.uploadUserDatatoFirestore(
                          uid: value.user!.uid,
                          profileUrl: "",
                          phoneNo: "+${widget.phoneNumber}",
                          username: "",
                          email: "");
                      setState(() {
                        isLoading = false;
                      });
                      Helper.toReplacementScreen(context, const NavBar());
                    }
                  });
                }
              }
            });
          } on FirebaseAuthException catch (e) {
            Helper.showSnack(context, e.toString());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          Helper.showSnack(context, e.toString());
        },
        codeSent: (String verificationId, int? resendtoken) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
        });
  }

  Future<bool> check() async {
    bool? res;
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode, smsCode: enteredPin))
          .then((value) async {
        if (value.user != null) {
          if (value.additionalUserInfo?.isNewUser == true) {
            await AuthServices.uploadUserDatatoFirestore(
                uid: value.user!.uid,
                profileUrl: "",
                phoneNo: "+${widget.phoneNumber}",
                username: "",
                email: "");
            setState(() {
              isLoading = false;
            });
            print("Success");
            res = true;
            Helper.toReplacementScreen(context, const NavBar());
          } else if (value.additionalUserInfo?.isNewUser == false) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(value.user?.uid)
                .get()
                .then((userData) async {
              if (userData.exists) {
                await AuthServices.setCurrentUserToMap(value.user?.uid);
                setState(() {
                  isLoading = false;
                });
                Get.snackbar('Hello', 'Welcome to spaco!',
                    colorText: secondaryColor,
                    icon: const Icon(
                      FeatherIcons.info,
                      color: secondaryColor,
                    ),
                    backgroundColor: successColor);

                res = true;
                Helper.toReplacementScreen(context, const NavBar());
              } else {
                await AuthServices.uploadUserDatatoFirestore(
                    uid: value.user!.uid,
                    profileUrl: "",
                    phoneNo: "+${widget.phoneNumber}",
                    username: "",
                    email: "");
                setState(() {
                  isLoading = false;
                });
                res = true;
                Helper.toReplacementScreen(context, const NavBar());
              }
            });
          }
        } else {
          res = false;
        }
      });
      return res!;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Helper.showSnack(context, e.toString());
      res = false;
      print(e);
      return res!;
    }
  }

  otpTopHeader() {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: SvgPicture.asset('assets/svg/phone_otp.svg')),
    );
  }

  arrowButton(function) {
    return Expanded(
      child: Center(
        child: ElevatedButton(
            onPressed: function,
            style: ElevatedButton.styleFrom(
                primary: tertiaryColor,
                padding: const EdgeInsets.all(13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            child: const Icon(
              CupertinoIcons.arrow_right,
              size: 30,
              color: secondaryColor,
            )),
      ),
    );
  }
}
