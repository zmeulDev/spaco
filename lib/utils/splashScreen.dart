import 'package:flutter/material.dart';
import 'package:spaco/services/authState.dart';
import 'package:spaco/utils/constant.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatelessWidget {
  ImageProvider imageProvider = AssetImage("assets/images/logo.png");

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      styleTextUnderTheLoader: TextStyle(fontSize: 10),
      loadingTextPadding: EdgeInsets.all(1),
      useLoader: true,
      seconds: 4,
      navigateAfterSeconds: Auth(),
      backgroundColor: Colors.white,
      title: Text(
        'stables',
        style: style1.copyWith(fontSize: 40),
      ),
      image: Image(image: imageProvider),
      loadingText: Text(
        "",
        style: style1,
      ),
      photoSize: 100.0,
      loaderColor: tertiaryColor,
    );
  }
}
