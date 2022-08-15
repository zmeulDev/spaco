import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/pages/Auth/chooseloginsignup.dart';
import 'package:spaco/services/auth_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/helper.dart';
import 'package:spaco/utils/spacoInputWidget.dart';
import 'package:spaco/utils/spacoUploadImage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  String saveText = 'Save';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? userImg;

  updateUserProfile() async {
    setState(() {
      isLoading = true;
      saveText = 'Saving...';
    });
    UserModel().username = nameController.text;
    UserModel().phoneNo = phoneNoController.text;
    UserModel().email = emailController.text;
    //UserModel().profileUrl = ?;
    var res = image == null
        ? await AuthServices.updateUserWithoutImage(UserModel().uid!)
        : await AuthServices.updateUser(image!, UserModel().uid!);
    if (res == "Success") {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Info', 'Profile updated.');
      Get.back();
    } else {
      setState(() {
        isLoading = false;
      });
      Helper.showSnack(context, res.toString());
    }
  }

  @override
  initState() {
    super.initState();
    userImg = UserModel().profileUrl;
    if (UserModel().phoneNo != "") {
      phoneNoController.text = UserModel().phoneNo!;
    }
    if (UserModel().username != "") {
      nameController.text = UserModel().username;
    }
    if (UserModel().email != "") {
      emailController.text = UserModel().email;
    }
  }

  File? image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  getBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: primaryColor,
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.05,
            ),
            Stack(
              children: [
                Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(1, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: spacoUploadImage('profile', image),
                ),
                Positioned(
                    right: 5,
                    bottom: 5,
                    child: CircleAvatar(
                      backgroundColor: fourthColor,
                      child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: secondaryColor,
                        ),
                        splashRadius: 5.0,
                        splashColor: Colors.grey,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: spacoInput('Choose your name', 'UserName',
                  TextInputType.text, CupertinoIcons.person, nameController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: spacoInput(
                  'Choose your email',
                  'Email',
                  TextInputType.emailAddress,
                  CupertinoIcons.mail,
                  emailController),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: TextField(
                controller: phoneNoController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Phone numberr',
                  labelStyle:
                      style3.copyWith(color: secondaryColor.withOpacity(0.5)),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1,
                      color: primaryColor,
                    ),
                  ),
                ),
                style: style2.copyWith(color: Colors.grey),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Get.height * 0.08),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.height * 0.04,
                    width: Get.width * 0.2,
                    child: ElevatedButton(
                      onPressed: isLoading == true
                          ? () {}
                          : () {
                              Get.back();
                            },
                      style: ElevatedButton.styleFrom(
                          primary: secondaryColor,
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: Text(
                        'Cancel',
                        style: style3.copyWith(color: primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.05,
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                    width: Get.width * 0.2,
                    child: ElevatedButton(
                      onPressed: () {
                        updateUserProfile();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: tertiaryColor,
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: Text(
                        saveText,
                        style: style3,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.05,
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                    width: Get.width * 0.2,
                    child: ElevatedButton(
                      onPressed: () {
                        AuthServices.signOut().then((value) {
                          Helper.toReplacementScreen(
                              context, const ChooseLoginSignup());
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          primary: tertiaryColor,
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: Text(
                        'Logout',
                        style: style3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            FeatherIcons.arrowLeft,
            color: secondaryColor,
          )),
      backgroundColor: primaryColor,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        'Edit Profile',
        style: style1.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}
