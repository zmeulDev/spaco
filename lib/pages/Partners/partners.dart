import 'dart:io';
import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/services/partner_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/displayImage.dart';
import 'package:spaco/utils/getImages.dart';
import 'package:spaco/utils/spacoInputWidget.dart';
import 'package:spaco/utils/loading.dart';

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
          icon: Icon(
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
        icon: Icon(
          FeatherIcons.info,
          color: secondaryColor,
        ),
        backgroundColor: errorColor);
  }

  partnerTopHeader() {
    return Container(
      width: Get.width,
      height: Get.height * 0.20,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.0),
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

  partnerAddWidget() {
    return Container(
      height: Get.height * 0.05,
      width: Get.width * 0.933,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: secondaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.all(2),
            height: Get.height * 0.2,
            width: Get.width * 0.30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: tertiaryColor,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  clearForm();
                  partnerAddSheet();
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

  partnerBody() {
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
                  height: Get.height * 0.4,
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset('assets/svg/nothing.svg'));
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
                      return GestureDetector(
                        onTap: () {
                          partnerDetailSheet(partnersList[index]['uid']);
                        },
                        child: Container(
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
                                            FeatherIcons.coffee,
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
                                      width: Get.width * 0.05,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            partnersList[index]['partnername'],
                                            style: style2,
                                          ),
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
                        ),
                      );
                    }),
              );
            }
          }
        });
  }

  partnerAddSheet() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: sixthColor,
          image: DecorationImage(
            image: AssetImage('assets/card_bck.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(primaryColor, BlendMode.hardLight),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        height: Get.height * 0.6,
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
                    child: displayImage('partner'),
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
                height: Get.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput(
                        'Partner name',
                        'Name',
                        TextInputType.text,
                        FeatherIcons.file,
                        partnerNameController),
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
                margin: EdgeInsets.only(top: Get.height * 0.04),
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
                      icon: Icon(
                        FeatherIcons.x,
                        size: 28,
                        color: secondaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: isLoading == true
                          ? () {}
                          : () {
                              partnerStore();
                            },
                      icon: Icon(
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

  partnerDetailSheet(uid) {
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
                                        offset: Offset(
                                            1, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: AvatarView(
                                    radius: 75,
                                    borderColor: secondaryColor,
                                    avatarType: AvatarType.CIRCLE,
                                    backgroundColor: primaryColor,
                                    imagePath: detail['profileurl'] == ''
                                        ? 'assets/user.png'
                                        : detail['profileurl'],
                                    placeHolder: Container(
                                      color: secondaryColor,
                                      child: Icon(
                                        FeatherIcons.user,
                                        size: 36,
                                      ),
                                    ),
                                    errorWidget: Container(
                                      color: fourthColor,
                                      child: Icon(
                                        FeatherIcons.user,
                                        size: 36,
                                      ),
                                    ),
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
                                    icon: Icon(
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
                                    icon: Icon(
                                      FeatherIcons.trash,
                                      size: 28,
                                      color: errorColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      partnerUpdate(detail);
                                    },
                                    icon: Icon(
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
                return Text("No data");
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
            partnerTopHeader(),
            partnerAddWidget(),
            partnerBody(),
          ],
        ),
      ),
    );
  }
}
