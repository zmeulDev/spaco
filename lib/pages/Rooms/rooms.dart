import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/services/partner_services.dart';
import 'package:spaco/services/room_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/displayImage.dart';
import 'package:spaco/utils/getImages.dart';
import 'package:spaco/utils/inputwidget.dart';
import 'package:spaco/utils/loading.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  bool isLoading = false;
  bool isChecked = false;

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
    // TODO clear image cache on multiple add and update
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  roomStore() async {
    // store partner in firebase
    // TODO remove uid
    var partnerImageUrlController = _image == null
        ? null
        : await PartnerServices.uploadPartnerImageToFirebase(_image);

    RoomServices.uploadRoomDataToFirestore(
            uid: RoomServices.roomRef.doc().id,
            partnerContact: partnerContactController.text,
            partnerProfile: partnerImageUrlController,
            partnerName: partnerNameController.text,
            partnerEmail: partnerEmailController.text,
            partnerPhone: partnerPhoneController.text)
        .whenComplete(() {
      Get.back();
      Get.snackbar('Info', 'Room added.');
    });
  }

  roomUpdate(detail) async {
    var partnerContactUpdate = partnerContactController.text.isEmpty
        ? detail['partnercontact']
        : partnerContactController.text;

    var partnerImageUrlController = _image == null
        ? detail['profileurl']
        : await RoomServices.uploadRoomImageToFirebase(_image);

    var partnerNameUpdate = partnerNameController.text.isEmpty
        ? detail['partnername']
        : partnerNameController.text;

    var partnerEmailUpdate = partnerEmailController.text.isEmpty
        ? detail['partneremail']
        : partnerEmailController.text;

    var partnerPhoneUpdate = partnerPhoneController.text.isEmpty
        ? detail['partnerphone']
        : partnerPhoneController.text;

    RoomServices.updateRoomDataInFirestore(
            detail.reference.id,
            partnerContactUpdate,
            partnerImageUrlController,
            partnerNameUpdate,
            partnerEmailUpdate,
            partnerPhoneUpdate)
        .whenComplete(() {
      clearForm();
      Get.back();
      Get.snackbar('Info', 'Room updated.');
    });
  }

  roomDelete(detail) async {
    // delete partner from firebase and related image storage
    // TODO: close bottomsheet on delete
    // TODO snackbar color to red
    RoomServices.deleteRoom(detail.id);
    detail['profileurl'] != ''
        ? RoomServices.deleteRoomImage(detail['profileurl'])
        : null;
    Get.back();
    Get.snackbar('Delete', 'partner deleted');
  }

  roomTopHeader(height, width) {
    return Container(
      width: width,
      height: height * 0.37,
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
                height: height * 0.27,
                child: Lottie.asset('assets/animation/meeting.json')),
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
                          clearForm();
                          roomAddSheet(height, width);
                        },
                        child: Text(
                          'Add room',
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

  roomBody(height, width) {
    CollectionReference roomsCollection =
        FirebaseFirestore.instance.collection('rooms');

    return StreamBuilder(
        stream: roomsCollection.snapshots(),
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
                  padding: EdgeInsets.all(20),
                  child: Lottie.asset('assets/animation/nothing.json'));
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
                          roomDetailSheet(
                              height, width, partnersList[index]['uid']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: sixthColor,
                            image: DecorationImage(
                              image: AssetImage('assets/card_bck.jpeg'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  fourthColor, BlendMode.modulate),
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
                                          partnersList[index]['partnercontact'],
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
                        ),
                      );
                    }),
              );
            }
          }
        });
  }

  roomAddSheet(height, width) {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: sixthColor,
          image: DecorationImage(
            image: AssetImage('assets/card_bck.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(fourthColor, BlendMode.modulate),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        height: height * 0.6,
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'Add new room',
                style: style1,
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
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput(
                        'Partner name',
                        'Name',
                        TextInputType.text,
                        Iconsax.note5,
                        partnerNameController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'Partner email',
                        'Email',
                        TextInputType.emailAddress,
                        Iconsax.message,
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
                        Iconsax.profile_tick,
                        partnerContactController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'Partner phone',
                        'Phone',
                        TextInputType.phone,
                        Iconsax.mobile,
                        partnerPhoneController),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.04),
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
                            style: style2.copyWith(color: primaryColor),
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
                            roomStore();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: tertiaryColor,
                              padding: const EdgeInsets.all(13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Text(
                            'Save',
                            style: style2.copyWith(color: secondaryColor),
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

  roomDetailSheet(height, width, uid) {
    CollectionReference roomDetailCollection =
        FirebaseFirestore.instance.collection('rooms');

    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: sixthColor,
            image: DecorationImage(
              image: AssetImage('assets/card_bck.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(fourthColor, BlendMode.modulate),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          height: height * 0.85,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                roomDetailCollection.where('uid', isEqualTo: uid).snapshots(),
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
                              'Room details',
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
                                        Iconsax.user,
                                        size: 36,
                                      ),
                                    ),
                                    errorWidget: Container(
                                      color: fourthColor,
                                      child: Icon(
                                        Iconsax.user1,
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
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: spacoInput(
                                      'Partner name',
                                      detail['partnername'],
                                      TextInputType.text,
                                      Iconsax.note5,
                                      partnerNameController),
                                ),
                                Expanded(
                                  child: spacoInput(
                                      'Partner email',
                                      detail['partneremail'],
                                      TextInputType.emailAddress,
                                      Iconsax.message,
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
                                      Iconsax.profile_tick,
                                      partnerContactController),
                                ),
                                Expanded(
                                  child: spacoInput(
                                      'Partner phone',
                                      detail['partnerphone'],
                                      TextInputType.phone,
                                      Iconsax.mobile,
                                      partnerPhoneController),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      }),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.05),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            )),
                                        child: Text(
                                          'Cancel',
                                          style: style2.copyWith(
                                              color: primaryColor),
                                          overflow: TextOverflow.ellipsis,
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
                                          Get.back();
                                          Get.dialog(
                                            AlertDialog(
                                              title: const Text('Warning'),
                                              content: const Text(
                                                  'Room will be deleted!'),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Close"),
                                                  onPressed: () => Get.back(),
                                                ),
                                                TextButton(
                                                  child: const Text("Delete"),
                                                  onPressed: () =>
                                                      roomDelete(detail),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: errorColor,
                                            padding: const EdgeInsets.all(13),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            )),
                                        child: Text(
                                          'Delete',
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
                                          roomUpdate(detail);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: tertiaryColor,
                                            padding: const EdgeInsets.all(13),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            )),
                                        child: Text(
                                          'Update',
                                          style: style2.copyWith(
                                              color: secondaryColor),
                                        ),
                                      ),
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppBar('Rooms'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            roomTopHeader(height, width),
            roomBody(height, width),
          ],
        ),
      ),
    );
  }
}
