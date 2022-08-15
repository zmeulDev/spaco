import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spaco/Services/auth_services.dart';
import 'package:spaco/pages/Auth/chooseloginsignup.dart';
import 'package:spaco/pages/navbar.dart';
import 'package:spaco/utils/constant.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  initUserModel() async {
    var user = AuthServices.auth.currentUser;
    AuthServices.setCurrentUserToMap(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        const Duration(seconds: 3),
        () async => await AuthServices.getCurrentUser(),
      ),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: ChooseLoginSignup(),
            ),
          );
        } else {
          initUserModel();
          return const NavBar();
        }
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initUserModel() async {
    var user = AuthServices.auth.currentUser;
    if (user != null) {
      AuthServices.setCurrentUserToMap(user.uid);
    }
  }

  @override
  void initState() {
    initUserModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: logoWidget(),
        splashIconSize: 300,
        nextScreen: const ChooseLoginSignup(),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: primaryColor,
      ),
    );
  }
}

logoWidget() {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/logo/spaco_logo_green_512.png',
          height: Get.height * 0.15,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: Get.height * 0.20),
        child: Text(
          'spaco',
          style: style1.copyWith(
            fontSize: Get.height * 0.05,
          ),
        ),
      ),
    ],
  );
}
