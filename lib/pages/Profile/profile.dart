import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/pages/Auth/chooseloginsignup.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/pages/imageview.dart';
import 'package:spaco/pages/profile/editprofile.dart';
import 'package:spaco/services/auth_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/helper.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppBar(),
      body: ListView(
        children: [
          Container(
            width: width,
            height: height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: primaryColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        UserModel().profileUrl == ''
                            ? Icon(
                                Iconsax.user,
                                size: 128,
                                color: tertiaryColor,
                              )
                            : ImageViewPage(img: UserModel().profileUrl),
                      );
                    },
                    child: createAvatarWidget(55),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  UserModel().username != ''
                      ? Text(
                          UserModel().username,
                          style: style2.copyWith(
                              color: secondaryColor, fontSize: 14),
                        )
                      : Text(
                          ' Name',
                          style: style2.copyWith(
                              color: secondaryColor, fontSize: 14),
                        ),
                  UserModel().email != ''
                      ? Text(
                          UserModel().email,
                          style: style2.copyWith(
                              color: secondaryColor, fontSize: 14),
                        )
                      : Text(
                          'Email',
                          style: style2.copyWith(
                              color: secondaryColor, fontSize: 14),
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    UserModel().phoneNo!,
                    style: style2.copyWith(
                        color: secondaryColor.withOpacity(0.7), fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          //Space
          SizedBox(
            height: 20,
          ),
          Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  AuthServices.signOut().then((value) {
                    Helper.toReplacementScreen(context, ChooseLoginSignup());
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: tertiaryColor,
                  onPrimary: Colors.white,
                ),
                child: Text('Logout')),
          ),
          //Space
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  getAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.to(Home());
        },
        icon: Icon(
          Iconsax.hierarchy_square,
          color: secondaryColor,
        ),
      ),
      backgroundColor: primaryColor,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        'Profile',
        style: style1,
      ),
      actions: [
        IconButton(
            onPressed: () {
              Get.to(EditProfile())!.then((value) {
                setState(() {});
              });
            },
            icon: Icon(
              Iconsax.edit,
              color: secondaryColor,
              size: 22,
            )),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
