import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/pages/Booking/booking.dart';
import 'package:spaco/pages/Spaces/spaces.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/pages/profile/editprofile.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/spacoCardWidget.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  getProfileAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.to(const Home());
        },
        icon: Image.asset(
          'assets/logo/spaco_logo_black_512.png',
          height: Get.height * 0.030,
          fit: BoxFit.contain,
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
              Get.to(() => const EditProfile())!.then((value) {
                setState(() {});
              });
            },
            icon: const Icon(
              FeatherIcons.edit,
              color: primaryColor,
              size: 22,
            )),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  profileTopHeader() {
    return Container(
      width: Get.width,
      height: Get.height * 0.30,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.17,
              width: Get.width * 0.40,
              child: createAvatarWidget(12),
            ),
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
            const SizedBox(
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
          Column(
            children: [
              profileTopHeader(),
              SizedBox(
                height: Get.height * 0.01,
              ),
              profileBodyDetails(),
            ],
          ),
        ],
      ),
    );
  }

  profileBodyDetails() {
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.11,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              spacoCard(tertiaryColor, 'Booking', '#reserve',
                  FeatherIcons.calendar, const Bookings()),
              spacoCard(secondaryColor, 'Partners', '#colaborate',
                  FeatherIcons.hexagon, const Home()),
              spacoCard(fourthColor, 'Rooms', '#space', FeatherIcons.airplay,
                  const Spaces()),
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
