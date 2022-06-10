import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/services/partner_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/displayImage.dart';
import 'package:spaco/utils/getImages.dart';
import 'package:spaco/utils/inputwidget.dart';
import 'package:spaco/utils/loading.dart';

class Partners extends StatefulWidget {
  const Partners({Key? key}) : super(key: key);

  @override
  State<Partners> createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  bool isLoading = false;
  TextEditingController partnerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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

  uploadPartner() async {
    String imageUrl =
        await PartnerServices.uploadPartnerImageToFirebase(_image);

    PartnerServices.uploadPartnerDataToFirestore(
            partnerName: partnerNameController.text,
            email: emailController.text,
            profileUrl: imageUrl)
        .whenComplete(() {
      Get.back();
      Get.snackbar('Info', 'Profile updated.');
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppBar('Partners'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            topContainer(height, width),
            partnerDetailsContainer(height, width),
          ],
        ),
      ),
    );
  }

  topContainer(height, width) {
    return Container(
      width: width,
      height: height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: primaryColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(13.0),
        child: Column(
          children: [
            Container(
                height: height * 0.21,
                child: Lottie.asset('assets/animation/partners.json')),
            Container(
              height: height * 0.05,
              width: width * 0.933,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: secondaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.all(2),
                    height: height * 0.2,
                    width: width * 0.30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: tertiaryColor,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          addPartner(height, width);
                        },
                        child: Text(
                          'Add partner',
                          style: style2.copyWith(color: secondaryColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addPartner(height, width) {
    return Get.bottomSheet(
      Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Add new partner',
              style: style1.copyWith(color: secondaryColor),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
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
            spacoInput('Type partner name', 'Name', TextInputType.text,
                Iconsax.text, partnerNameController),
            spacoInput('Type email', 'Email', TextInputType.emailAddress,
                Iconsax.text, emailController),
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
                          uploadPartner();
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
      backgroundColor: primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  partnerDetailsContainer(height, width) {
    CollectionReference partnersCollection =
        FirebaseFirestore.instance.collection('partners');

    return StreamBuilder(
        stream: partnersCollection.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loading(),
            );
          } else {
            List<DocumentSnapshot> partnersList = snapshot.data.docs;
            if (partnersList.isEmpty) {
              return Container(
                height: height * 0.4,
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text('There are no partners at the moment.'),
                    Icon(
                      Iconsax.battery_empty,
                      color: primaryColor,
                      size: 64,
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(12),
                child: GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemCount: partnersList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: sixthColor,
                          image: DecorationImage(
                            image: AssetImage('assets/card_bck.jpeg'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                primaryColor, BlendMode.hardLight),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5, left: 10, right: 5, bottom: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  partnersList[index]['profileurl'] == ''
                                      ? Icon(
                                          Iconsax.hierarchy_square,
                                          color: secondaryColor,
                                          size: 44,
                                        )
                                      : GetImage(
                                          imagePath: partnersList[index]
                                              ['profileurl'],
                                          width: 45,
                                          height: 45,
                                          radius: 12,
                                        ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        partnersList[index]['partnername'],
                                        style: style2.copyWith(
                                            color: secondaryColor),
                                      ),
                                      Text(
                                        partnersList[index]['partnername'],
                                        style: style2.copyWith(
                                            color: secondaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
          }
        });
  }
}
