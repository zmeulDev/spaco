import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaco/pages/Partners/addPartner.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/services/partner_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/spacoInputWidget.dart';
import 'package:spaco/utils/spacoLoading.dart';
import 'package:spaco/utils/spacoShowImage.dart';

class Partners extends StatefulWidget {
  const Partners({Key? key}) : super(key: key);

  @override
  State<Partners> createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  bool isLoading = false;
  TextEditingController partnerContactController = TextEditingController();
  TextEditingController partnerNameController = TextEditingController();
  TextEditingController partnerEmailController = TextEditingController();
  TextEditingController partnerPhoneController = TextEditingController();

  void clearForm() {
    setState(() {
      partnerContactController.clear();
      partnerNameController.clear();
      partnerEmailController.clear();
      partnerPhoneController.clear();
    });
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

  partnerUpdate(detail) async {
    var partnerContactUpdate = partnerContactController.text.isEmpty
        ? detail['partnercontact']
        : partnerContactController.text;

    var partnerImageUrlController = _image == null
        ? detail['profileurl']
        : await PartnerServices.uploadPartnerImageToFirebase(_image);

    var partnerNameUpdate = partnerNameController.text.isEmpty
        ? detail['partnername']
        : partnerNameController.text;

    var partnerEmailUpdate = partnerEmailController.text.isEmpty
        ? detail['partneremail']
        : partnerEmailController.text;

    var partnerPhoneUpdate = partnerPhoneController.text.isEmpty
        ? detail['partnerphone']
        : partnerPhoneController.text;

    PartnerServices.updatePartnerDataInFirestore(
            detail.reference.id,
            partnerContactUpdate,
            partnerImageUrlController,
            partnerNameUpdate,
            partnerEmailUpdate,
            partnerPhoneUpdate)
        .whenComplete(() {
      clearForm();
      Get.back();
      Get.snackbar('Update', 'Partner updated successfully.',
          colorText: secondaryColor,
          icon: const Icon(
            FeatherIcons.info,
            color: secondaryColor,
          ),
          backgroundColor: successColor);
    });
  }

  partnerDelete(detail) async {
    // delete partner from firebase and related image storage
    PartnerServices.deletePartener(detail.id);
    detail['profileurl'] != ''
        ? PartnerServices.deletePartnerImage(detail['profileurl'])
        : null;
    Get.back();
    Get.snackbar('Delete', 'Partner deleted successfully.',
        colorText: secondaryColor,
        icon: const Icon(
          FeatherIcons.info,
          color: secondaryColor,
        ),
        backgroundColor: errorColor);
  }

  partnerTopWidget() {
    return Container(
      width: Get.width,
      height: Get.height * 0.20,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Container(
                height: Get.height * 0.18,
                child: SvgPicture.asset('assets/svg/partners.svg')),
          ],
        ),
      ),
    );
  }

  partnerMiddleWidget() {
    return Container(
      height: Get.height * 0.05,
      width: Get.width * 0.933,
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: secondaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.all(2),
            height: Get.height * 0.2,
            width: Get.width * 0.30,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: tertiaryColor,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  clearForm();
                  partnerAddForm();
                },
                child: Text(
                  'Add partner',
                  style: style3,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  partnerBodyWidget() {
    CollectionReference partnersCollection =
        FirebaseFirestore.instance.collection('partners');

    return StreamBuilder(
        stream: partnersCollection.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: spacoLoading(),
            );
          } else {
            List<DocumentSnapshot> partnersList = snapshot.data.docs;
            if (partnersList.isEmpty) {
              return Container(
                  height: Get.height * 0.4,
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset('assets/svg/nothing.svg'));
            } else {
              return Container(
                margin: const EdgeInsets.all(12),
                child: GridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: partnersList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          partnerDetailForm(partnersList[index]['uid']);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  partnersList[index]['profileurl'] == ''
                                      ? Image.asset(
                                          'assets/logo/spaco_logo_green_512.png',
                                          fit: BoxFit.cover,
                                          height: Get.height * 0.04,
                                        )
                                      : SpacoShowImage(
                                          imagePath: partnersList[index]
                                              ['profileurl'],
                                          width: 60,
                                          height: 60,
                                          radius: 12,
                                        ),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        partnersList[index]['partnername'],
                                        style: style2,
                                      ),
                                      Text(
                                        partnersList[index]['partnercontact'],
                                        style: style3,
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

  partnerAddForm() {
    return Get.bottomSheet(
      const AddPartner(),
    );
  }

  partnerDetailForm(uid) {
    CollectionReference partnerDetailCollection =
        FirebaseFirestore.instance.collection('partners');

    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          height: Get.height * 0.6,
          child: StreamBuilder<QuerySnapshot>(
            stream: partnerDetailCollection
                .where('uid', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot detail = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              'Partner details',
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
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: SpacoShowImage(
                                    imagePath: detail['profileurl'],
                                    width: 60,
                                    height: 60,
                                    radius: 12,
                                  ),
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
                              height: Get.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: spacoInput(
                                      'Partner name',
                                      detail['partnername'],
                                      TextInputType.text,
                                      FeatherIcons.file,
                                      partnerNameController),
                                ),
                                Expanded(
                                  child: spacoInput(
                                      'Partner email',
                                      detail['partneremail'],
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
                                      detail['partnercontact'],
                                      TextInputType.text,
                                      FeatherIcons.users,
                                      partnerContactController),
                                ),
                                Expanded(
                                  child: spacoInput(
                                      'Partner phone',
                                      detail['partnerphone'],
                                      TextInputType.phone,
                                      FeatherIcons.phone,
                                      partnerPhoneController),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Get.height * 0.05),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: isLoading == true
                                        ? () {}
                                        : () {
                                            Get.back();
                                          },
                                    icon: const Icon(
                                      FeatherIcons.x,
                                      size: 28,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.back();
                                      Get.dialog(
                                        AlertDialog(
                                          backgroundColor: primaryColor,
                                          title: Text(
                                            'Warning',
                                            style: style2,
                                          ),
                                          content: Text(
                                            'Partner [ ${detail['partnername']} ] will be deleted!',
                                            style: style2,
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                "Close",
                                                style: style3,
                                              ),
                                              onPressed: () => Get.back(),
                                            ),
                                            TextButton(
                                              child: Text(
                                                "Delete",
                                                style: style3.copyWith(
                                                    color: errorColor),
                                              ),
                                              onPressed: () =>
                                                  partnerDelete(detail),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      FeatherIcons.trash,
                                      size: 28,
                                      color: errorColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      partnerUpdate(detail);
                                    },
                                    icon: const Icon(
                                      FeatherIcons.save,
                                      size: 28,
                                      color: tertiaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Text("No data");
              }
            },
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Partners', context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            partnerTopWidget(),
            partnerMiddleWidget(),
            partnerBodyWidget(),
          ],
        ),
      ),
    );
  }
}
