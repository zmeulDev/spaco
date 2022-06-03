import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaco/Services/auth_services.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/helper.dart';
import 'package:spaco/utils/inputwidget.dart';
import 'package:spaco/widgets/createAvatarWidget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? userImg;

  updateData() async {
    setState(() {
      isLoading = true;
    });
    UserModel().username = nameController.text;
    UserModel().phoneNo = phoneNoController.text;
    UserModel().email = emailController.text;
    //UserModel().profileUrl = ?;
    var res = _image == null
        ? await AuthServices.updateUserDatainFirestoreWithoutImage(
            UserModel().uid!)
        : await AuthServices.updateUserDatainFirestore(
            _image!, UserModel().uid!);
    if (res == "Success") {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Profile updated successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
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
    if (UserModel().phoneNo != null || UserModel().phoneNo != "") {
      phoneNoController.text = UserModel().phoneNo!;
    }
    if (UserModel().username != null || UserModel().username != "") {
      nameController.text = UserModel().username;
    }
    if (UserModel().email != null || UserModel().email != "") {
      emailController.text = UserModel().email;
    }
  }

  Widget displayImage() {
    if (_image == null) {
      return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tertiaryColor,
        ),
        child: createAvatarWidget(75),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(75),
        child: Image.file(
          _image!,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        color: primaryColor,
        width: width,
        height: height,
        child: Column(
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: displayImage(),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: fourthColor,
                      child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(
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
              height: height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: spacoInput('Choose your name', 'UserName',
                  TextInputType.text, Iconsax.user, nameController),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: spacoInput(
                  'Choose your email',
                  'Email',
                  TextInputType.emailAddress,
                  Iconsax.message4,
                  emailController),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: phoneNoController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  labelText: 'Phone number',
                  hintStyle: style2.copyWith(color: secondaryColor),
                  labelStyle:
                      style3.copyWith(color: secondaryColor.withOpacity(0.5)),
                  contentPadding:
                      EdgeInsets.only(left: 8, bottom: 12, right: 5, top: 5),
                  suffixIcon: Icon(
                    CupertinoIcons.phone,
                    color: primaryColor.withOpacity(0.5),
                    size: 20,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: style2.copyWith(color: Colors.grey),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.08),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 52,
                    width: 80,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: isLoading == true
                            ? () {}
                            : () {
                                Get.back();
                              },
                        style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            padding: const EdgeInsets.all(13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        child: Text(
                          'Cancel',
                          style: style2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 52,
                    width: 80,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          updateData();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            padding: const EdgeInsets.all(13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        child: Text(
                          'Save',
                          style: style2,
                        ),
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
          icon: Icon(
            Iconsax.arrow_left,
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
