import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaco/services/partner_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/spacoUploadImage.dart';
import 'package:spaco/utils/spacoButtonsAction.dart';
import 'package:spaco/utils/spacoInputWidget.dart';

class AddPartner extends StatefulWidget {
  const AddPartner({Key? key}) : super(key: key);

  @override
  State<AddPartner> createState() => _AddPartnerState();
}

class _AddPartnerState extends State<AddPartner> {
  bool isLoading = false;
  TextEditingController partnerContactController = TextEditingController();
  TextEditingController partnerNameController = TextEditingController();
  TextEditingController partnerEmailController = TextEditingController();
  TextEditingController partnerPhoneController = TextEditingController();

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

  partnerStore() async {
    // store partner in firebase
    var partnerImageUrlController = _image == null
        ? null
        : await PartnerServices.uploadPartnerImageToFirebase(_image);

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
          icon: Icon(
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
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: spacoUploadImage('partner', _image),
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
                        icon: Icon(
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
            Container(
                height: 100,
                width: 200,
                child: SpacoButtonsAction(saveButtonAction: partnerStore)),
          ],
        ),
      ),
    );
  }
}
