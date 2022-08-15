// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaco/services/partner_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/spacoUploadImage.dart';
import 'package:spaco/utils/spacoInputWidget.dart';

class AddPartner extends StatefulWidget {
  const AddPartner({Key? key}) : super(key: key);

  @override
  State<AddPartner> createState() => _AddPartnerState();
}

class _AddPartnerState extends State<AddPartner> {
  bool isLoading = false;
  String saveText = 'Create';
  Color saveColor = tertiaryColor;
  TextEditingController partnerContactController = TextEditingController();
  TextEditingController partnerNameController = TextEditingController();
  TextEditingController partnerEmailController = TextEditingController();
  TextEditingController partnerPhoneController = TextEditingController();

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

  partnerStore() async {
    // store partner in firebase
    var partnerImageUrlController = image == null
        ? null
        : await PartnerServices.uploadPartnerImageToFirebase(image);

    PartnerServices.uploadPartnerDataToFirestore(
            uid: PartnerServices.partnerRef.doc().id,
            partnerContact: partnerContactController.text,
            partnerProfile: partnerImageUrlController,
            partnerName: partnerNameController.text,
            partnerEmail: partnerEmailController.text,
            partnerPhone: partnerPhoneController.text)
        .whenComplete(() {
      Get.back();
      Get.snackbar('Create', 'Partner created successfully.',
          colorText: secondaryColor,
          icon: const Icon(
            FeatherIcons.info,
            color: secondaryColor,
          ),
          backgroundColor: successColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: Get.height * 0.6,
      width: Get.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              'Add new partner',
              style: style1.copyWith(color: secondaryColor),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Stack(
              children: [
                Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: spacoUploadImage('partner', image),
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
                        splashRadius: 2.0,
                        splashColor: tertiaryColor,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: spacoInput('Partner name', 'Name', TextInputType.text,
                      FeatherIcons.file, partnerNameController),
                ),
                Expanded(
                  child: spacoInput(
                      'Partner email',
                      'Email',
                      TextInputType.emailAddress,
                      FeatherIcons.mail,
                      partnerEmailController),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: spacoInput(
                      'Partner contact',
                      'Contact',
                      TextInputType.text,
                      FeatherIcons.users,
                      partnerContactController),
                ),
                Expanded(
                  child: spacoInput(
                      'Partner phone',
                      'Phone',
                      TextInputType.phone,
                      FeatherIcons.phone,
                      partnerPhoneController),
                ),
              ],
            ),
            SafeArea(
              minimum: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.height * 0.04,
                    width: Get.width * 0.2,
                    child: ElevatedButton(
                      onPressed: () {
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
                        setState(() {
                          isLoading = true;
                          partnerStore();
                          saveText = 'Saving...';
                          saveColor = warningColor;
                          isLoading = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          primary: saveColor,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
