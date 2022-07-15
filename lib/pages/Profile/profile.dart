import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/pages/Auth/chooseloginsignup.dart';
import 'package:spaco/pages/Booking/booking.dart';
import 'package:spaco/pages/Rooms/rooms.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/pages/imageview.dart';
import 'package:spaco/pages/profile/editprofile.dart';
import 'package:spaco/services/auth_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/helper.dart';
import 'package:spaco/utils/spacoCard.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  getProfileAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.to(Home());
        },
        icon: Icon(
          FeatherIcons.coffee,
          color: primaryColor,
        ),
      ),
      backgroundColor: scaffoldColor,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        'Profile',
        style: style1.copyWith(color: primaryColor),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Get.to(EditProfile())!.then((value) {
                setState(() {});
              });
            },
            icon: Icon(
              FeatherIcons.edit,
              color: primaryColor,
              size: 22,
            )),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  profileTopHeader() {
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            createAvatarWidget(55),
            SizedBox(
              height: Get.height * 0.02,
            ),
            UserModel().username != ''
                ? Text(
                    UserModel().username,
                    style: style2,
                  )
                : Text(
                    ' Name',
                    style: style2,
                  ),
            UserModel().email != ''
                ? Text(
                    UserModel().email,
                    style: style3,
                  )
                : Text(
                    'Email',
                    style: style3,
                  ),
            SizedBox(
              height: 5,
            ),
            Text(
              UserModel().phoneNo!,
              style: style3.copyWith(color: secondaryColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  profileBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                profileTopHeader(),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                profileBodyDetails(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  profileBodyDetails() {
    return Container(
      width: Get.width,
      height: Get.height * 0.11,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              spacoCard(scaffoldColor, 'Booking', '#reserve',
                  FeatherIcons.calendar, Bookings()),
              spacoCard(scaffoldColor, 'Partners', '#colaborate',
                  FeatherIcons.hexagon, Home()),
              spacoCard(scaffoldColor, 'Rooms', '#space', FeatherIcons.airplay,
                  Rooms()),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getProfileAppBar(),
      body: profileBody(),
    );
  }
}
