import 'dart:io';
import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  roomTopHeader() {
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
        padding: EdgeInsets.all(1.0),
        child: Column(
          children: [
            Container(
                height: Get.height * 0.18,
                child: SvgPicture.asset('assets/svg/rooms.svg')),
          ],
        ),
      ),
    );
  }

  roomBody() {
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
            List<DocumentSnapshot> roomsList = snapshot.data.docs;
            if (roomsList.isEmpty) {
              return Container(
                  height: Get.height * 0.4,
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset('assets/svg/nothing.svg'));
            } else {
              return Container(
                margin: EdgeInsets.all(12),
                child: GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1.3 / 1.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemCount: roomsList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          roomDetailSheet(roomsList[index]['uid']);
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8),
                                  height: Get.height * 0.2,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          roomsList[index]['profileurl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 8, left: 12, right: 12, bottom: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              roomsList[index]['partnername'],
                                              style: style2.copyWith(
                                                  color: primaryColor),
                                            ),
                                            Text(
                                              roomsList[index]['partneremail'],
                                              style: style3.copyWith(
                                                  color: primaryColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  FeatherIcons.users,
                                                  size: 13,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "8",
                                                  style: style3.copyWith(
                                                      color: primaryColor),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  FeatherIcons.monitor,
                                                  size: 13,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "1",
                                                  style: style3.copyWith(
                                                      color: primaryColor),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  FeatherIcons.wind,
                                                  size: 13,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Yes",
                                                  style: style3.copyWith(
                                                      color: primaryColor),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              );
            }
          }
        });
  }

  roomAddWidget() {
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
                  roomAddSheet();
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
    );
  }

  roomAddSheet() {
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
        height: Get.height * 0.6,
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
                        FeatherIcons.user,
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

  roomDetailSheet(uid) {
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
          height: Get.height * 0.85,
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
                              margin: EdgeInsets.only(top: Get.height * 0.05),
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
    return Scaffold(
      appBar: getAppBar('Rooms', context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            roomTopHeader(),
            roomAddWidget(),
            roomBody(),
          ],
        ),
      ),
    );
  }
}
