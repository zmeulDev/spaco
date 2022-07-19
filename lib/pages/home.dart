import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/utils/constant.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  getBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                homeInfoContainer(),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                homeDetailsContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  homeInfoContainer() {
    return Container(
      width: Get.width,
      height: Get.height * 0.30,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            fourthColor,
            primaryColor,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserModel().username != ''
                        ? Text(
                            UserModel().username,
                            style: style2.copyWith(
                                color: secondaryColor, fontSize: 18),
                          )
                        : Text('Hello!',
                            style: style2.copyWith(
                                color: secondaryColor, fontSize: 18)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  homeDetailsContainer() {
    return Container(
      width: Get.width * 0.5,
      height: Get.height * 0.13,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  FeatherIcons.coffee,
                  color: secondaryColor,
                  size: 44,
                ),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello!',
                        style: style2.copyWith(
                            color: secondaryColor, fontSize: 18)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('spaco', context),
      body: getBody(),
    );
  }
}
