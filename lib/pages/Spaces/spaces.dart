import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaco/pages/Spaces/spaceCard.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/services/space_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/spacoCardImage.dart';
import 'package:spaco/utils/spacoInputWidget.dart';
import 'package:spaco/utils/spacoLoading.dart';

class Spaces extends StatefulWidget {
  const Spaces({Key? key}) : super(key: key);

  @override
  State<Spaces> createState() => _SpacesState();
}

class _SpacesState extends State<Spaces> {
  bool isLoading = false;
  bool isChecked = false;

  TextEditingController spaceNameController = TextEditingController();
  TextEditingController spaceEmailController = TextEditingController();
  TextEditingController spaceNoPeopleController = TextEditingController();
  TextEditingController spaceTVController = TextEditingController();
  TextEditingController spaceWhiteBoardController = TextEditingController();
  TextEditingController spaceAirConditioningController =
      TextEditingController();
  TextEditingController spaceImage1Controller = TextEditingController();
  TextEditingController spaceImage2Controller = TextEditingController();
  TextEditingController spaceImage3Controller = TextEditingController();
  TextEditingController spaceImage4Controller = TextEditingController();
  TextEditingController spaceImage5Controller = TextEditingController();
  TextEditingController spaceIsFavoriteController = TextEditingController();
  TextEditingController spaceIsMainController = TextEditingController();
  TextEditingController spaceStatusController = TextEditingController();
  TextEditingController spaceWifiController = TextEditingController();

  void clearForm() {
    setState(() {
      spaceNameController.clear();
      spaceEmailController.clear();
      spaceNoPeopleController.clear();
      spaceTVController.clear();
      spaceWhiteBoardController.clear();
      spaceAirConditioningController.clear();
      spaceImage1Controller.clear();
      spaceImage2Controller.clear();
      spaceImage3Controller.clear();
      spaceImage4Controller.clear();
      spaceImage5Controller.clear();
      spaceIsFavoriteController.clear();
      spaceIsMainController.clear();
      spaceStatusController.clear();
      spaceWifiController.clear();
    });
  }

  File? _image1;
  File? _image2;
  File? _image3;
  File? _image4;
  File? _image5;

  final picker = ImagePicker();
  final picker2 = ImagePicker();
  final picker3 = ImagePicker();
  final picker4 = ImagePicker();
  final picker5 = ImagePicker();

  Future getImage1() async {
    final pickedFile1 =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile1 != null) {
      setState(() {
        _image1 = File(pickedFile1.path);
      });
    }
  }

  Future getImage2() async {
    final pickedFile =
        await picker2.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        _image2 = File(pickedFile.path);
      });
    }
  }

  Future getImage3() async {
    final pickedFile =
        await picker3.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        _image3 = File(pickedFile.path);
      });
    }
  }

  Future getImage4() async {
    final pickedFile =
        await picker4.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        _image4 = File(pickedFile.path);
      });
    }
  }

  Future getImage5() async {
    final pickedFile =
        await picker5.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        _image5 = File(pickedFile.path);
      });
    }
  }

  spaceStore() async {
    // store partner in firebase

    var spaceImage1Store = _image1 == null
        ? ''
        : await SpaceServices.uploadSpaceImageToFirebase(_image1);

    var spaceImage2Store = _image2 == null
        ? ''
        : await SpaceServices.uploadSpaceImageToFirebase(_image2);

    var spaceImage3Store = _image3 == null
        ? ''
        : await SpaceServices.uploadSpaceImageToFirebase(_image3);

    var spaceImage4Store = _image4 == null
        ? ''
        : await SpaceServices.uploadSpaceImageToFirebase(_image4);

    var spaceImage5Store = _image5 == null
        ? ''
        : await SpaceServices.uploadSpaceImageToFirebase(_image5);

    SpaceServices.storeSpaceDataToFirestore(
      uid: SpaceServices.spaceRef.doc().id,
      spaceName: spaceNameController.text,
      spaceEmail: spaceEmailController.text,
      spaceNoPeople: spaceNoPeopleController.text,
      spaceTV: spaceTVController.text,
      spaceWhiteBoard: spaceWhiteBoardController.text,
      spaceAirConditioning: spaceAirConditioningController.text,
      spaceImage1: spaceImage1Store,
      spaceImage2: spaceImage2Store,
      spaceImage3: spaceImage3Store,
      spaceImage4: spaceImage4Store,
      spaceImage5: spaceImage5Store,
      spaceIsFavorite: spaceIsFavoriteController.text,
      spaceIsMain: spaceIsMainController.text,
      spaceStatus: spaceStatusController.text,
      spaceWifi: spaceWifiController.text,
    ).whenComplete(() {
      Get.back();
      Get.snackbar('Stored', 'Space added successfully.',
          colorText: secondaryColor,
          icon: const Icon(
            FeatherIcons.info,
            color: secondaryColor,
          ),
          backgroundColor: successColor);
    });
  }

  spaceUpdate(detail) async {
    var spaceNameUpdate = spaceNameController.text.isEmpty
        ? detail['spaceName']
        : spaceNameController.text;

    var spaceEmailUpdate = spaceEmailController.text.isEmpty
        ? detail['spaceEmail']
        : spaceEmailController.text;

    var spaceNoPeopleUpdate = spaceNoPeopleController.text.isEmpty
        ? detail['spaceNoPeople']
        : spaceNoPeopleController.text;

    var spaceTVUpdate = spaceTVController.text.isEmpty
        ? detail['spaceTV']
        : spaceTVController.text;

    var spaceWhiteBoardUpdate = spaceWhiteBoardController.text.isEmpty
        ? detail['spaceWhiteBoard']
        : spaceWhiteBoardController.text;

    var spaceAirConditioningUpdate = spaceAirConditioningController.text.isEmpty
        ? detail['spaceAirConditioning']
        : spaceAirConditioningController.text;

    var spaceImage1Update = _image1 == null
        ? detail['spaceImage1']
        : await SpaceServices.uploadSpaceImageToFirebase(_image1);

    var spaceImage2Update = _image2 == null
        ? detail['spaceImage2']
        : await SpaceServices.uploadSpaceImageToFirebase(_image2);

    var spaceImage3Update = _image3 == null
        ? detail['spaceImage3']
        : await SpaceServices.uploadSpaceImageToFirebase(_image3);

    var spaceImage4Update = _image4 == null
        ? detail['spaceImage4']
        : await SpaceServices.uploadSpaceImageToFirebase(_image4);

    var spaceImage5Update = _image5 == null
        ? detail['spaceImage5']
        : await SpaceServices.uploadSpaceImageToFirebase(_image5);

    var spaceIsFavoriteUpdate = spaceIsFavoriteController.text.isEmpty
        ? detail['spaceIsFavorite']
        : spaceIsFavoriteController.text;

    var spaceIsMainUpdate = spaceIsMainController.text.isEmpty
        ? detail['spaceIsMain']
        : spaceIsMainController.text;

    var spaceStatusUpdate = spaceStatusController.text.isEmpty
        ? detail['spaceStatus']
        : spaceStatusController.text;

    var spaceWifiUpdate = spaceWifiController.text.isEmpty
        ? detail['spaceWifi']
        : spaceWifiController.text;

    SpaceServices.updateSpaceDataInFirestore(
            detail.reference.id,
            spaceNameUpdate,
            spaceEmailUpdate,
            spaceNoPeopleUpdate,
            spaceTVUpdate,
            spaceWhiteBoardUpdate,
            spaceAirConditioningUpdate,
            spaceImage1Update,
            spaceImage2Update,
            spaceImage3Update,
            spaceImage4Update,
            spaceImage5Update,
            spaceIsFavoriteUpdate,
            spaceIsMainUpdate,
            spaceStatusUpdate,
            spaceWifiUpdate)
        .whenComplete(() {
      clearForm();
      Get.back();
      Get.snackbar('Update', 'Space updated successfully.',
          colorText: secondaryColor,
          icon: const Icon(
            FeatherIcons.info,
            color: secondaryColor,
          ),
          backgroundColor: successColor);
    });
  }

  spaceDelete(spaceDetail) async {
    // delete partner from firebase and related image storage
    SpaceServices.deleteSpace(spaceDetail.id);
    spaceDetail['spaceImage1'] != ''
        ? SpaceServices.deleteSpaceImage(spaceDetail['spaceImage1'])
        : null;
    spaceDetail['spaceImage2'] != ''
        ? SpaceServices.deleteSpaceImage(spaceDetail['spaceImage2'])
        : null;
    spaceDetail['spaceImage3'] != ''
        ? SpaceServices.deleteSpaceImage(spaceDetail['spaceImage3'])
        : null;
    spaceDetail['spaceImage4'] != ''
        ? SpaceServices.deleteSpaceImage(spaceDetail['spaceImage4'])
        : null;
    spaceDetail['spaceImage5'] != ''
        ? SpaceServices.deleteSpaceImage(spaceDetail['spaceImage5'])
        : null;
    Get.back();
    Get.snackbar('Deleted', 'Space deleted successfully.',
        colorText: secondaryColor,
        icon: const Icon(
          FeatherIcons.info,
          color: secondaryColor,
        ),
        backgroundColor: errorColor);
  }

  spaceTopHeader() {
    return Container(
      width: Get.width,
      height: Get.height * 0.20,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          const Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            Container(
                height: Get.height * 0.18,
                child: SvgPicture.asset('assets/svg/spaces.svg')),
          ],
        ),
      ),
    );
  }

  spaceBody() {
    CollectionReference spacesCollection =
        FirebaseFirestore.instance.collection('spaces');

    return StreamBuilder(
        stream: spacesCollection.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: spacoLoading(),
            );
          } else {
            List<DocumentSnapshot> spacesList = snapshot.data.docs;
            if (spacesList.isEmpty) {
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
                            childAspectRatio: 1.3 / 1.8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: spacesList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                          onTap: () {
                            clearForm();
                            spaceDetailSheet(spacesList[index]['uid']);
                          },
                          child: spaceCard(
                            spacesList[index]['spaceImage1'],
                            spacesList[index]['spaceName'],
                            spacesList[index]['spaceEmail'],
                            spacesList[index]['spaceNoPeople'],
                            spacesList[index]['spaceTV'],
                            spacesList[index]['spaceAirConditioning'],
                          ));
                    }),
              );
            }
          }
        });
  }

  spaceAddWidget() {
    return Container(
      height: Get.height * 0.05,
      width: Get.width * 0.933,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                  spaceAddSheet();
                },
                child: Text(
                  'Add space',
                  style: style2.copyWith(color: secondaryColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  spaceAddSheet() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        height: Get.height * 0.6,
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add new space',
                  style: style1,
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput('Space name', 'Name', TextInputType.text,
                        FeatherIcons.file, spaceNameController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'Space email',
                        'Email',
                        TextInputType.emailAddress,
                        FeatherIcons.mail,
                        spaceEmailController),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput(
                        'Ex: 8',
                        'Number of people',
                        TextInputType.text,
                        FeatherIcons.users,
                        spaceNoPeopleController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'TV or video projector?',
                        'TV',
                        TextInputType.text,
                        FeatherIcons.monitor,
                        spaceTVController),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput(
                        'Yes or No',
                        'Whiteboard',
                        TextInputType.text,
                        FeatherIcons.penTool,
                        spaceWhiteBoardController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'Yes or No',
                        'Air Conditioner',
                        TextInputType.phone,
                        FeatherIcons.wind,
                        spaceAirConditioningController),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput('Yes or No', 'Wi-Fi', TextInputType.text,
                        FeatherIcons.wifi, spaceWifiController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'Available or not',
                        'Status',
                        TextInputType.phone,
                        FeatherIcons.info,
                        spaceStatusController),
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
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 52,
                      width: 80,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            spaceStore();
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

  spaceDetailSheet(uid) {
    CollectionReference spaceDetailCollection =
        FirebaseFirestore.instance.collection('spaces');

    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          height: Get.height * 0.85,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                spaceDetailCollection.where('uid', isEqualTo: uid).snapshots(),
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
                              'Space details',
                              style: style1.copyWith(color: secondaryColor),
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Container(
                              width: Get.width,
                              height: Get.height * 0.25,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (() => getImage1()),
                                        child: spacoCardImage(
                                            detail['spaceImage1']),
                                      ),
                                      GestureDetector(
                                        onTap: (() => getImage2()),
                                        child: spacoCardImage(
                                            detail['spaceImage2']),
                                      ),
                                      GestureDetector(
                                        onTap: (() => getImage3()),
                                        child: spacoCardImage(
                                            detail['spaceImage3']),
                                      ),
                                      GestureDetector(
                                        onTap: (() => getImage4()),
                                        child: spacoCardImage(
                                            detail['spaceImage4']),
                                      ),
                                      GestureDetector(
                                        onTap: (() => getImage5()),
                                        child: spacoCardImage(
                                            detail['spaceImage5']),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: spacoInput(
                                      'Space name',
                                      detail['spaceName'],
                                      TextInputType.text,
                                      FeatherIcons.file,
                                      spaceNameController),
                                ),
                                Expanded(
                                  child: spacoInput(
                                      'Email',
                                      detail['spaceEmail'],
                                      TextInputType.emailAddress,
                                      FeatherIcons.mail,
                                      spaceEmailController),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: spacoInput(
                                      'No. of people',
                                      detail['spaceNoPeople'],
                                      TextInputType.text,
                                      FeatherIcons.users,
                                      spaceNoPeopleController),
                                ),
                                Expanded(
                                  child: spacoInput(
                                      'TV',
                                      detail['spaceTV'],
                                      TextInputType.phone,
                                      FeatherIcons.phone,
                                      spaceTVController),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: spacoInput(
                                      'Whiteboard',
                                      detail['spaceWhiteBoard'],
                                      TextInputType.text,
                                      FeatherIcons.users,
                                      spaceWhiteBoardController),
                                ),
                                Expanded(
                                  child: spacoInput(
                                      'Air Conditioner',
                                      detail['spaceAirConditioning'],
                                      TextInputType.phone,
                                      FeatherIcons.phone,
                                      spaceAirConditioningController),
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
                                          style: style3.copyWith(
                                              color: primaryColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
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
                                                  'space will be deleted!'),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Close"),
                                                  onPressed: () => Get.back(),
                                                ),
                                                TextButton(
                                                  child: const Text("Delete"),
                                                  onPressed: () =>
                                                      spaceDelete(detail),
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
                                          style: style3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 52,
                                    width: 80,
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          spaceUpdate(detail);
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
                                          style: style3,
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
      appBar: getAppBar('spaces', context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            spaceTopHeader(),
            spaceAddWidget(),
            spaceBody(),
          ],
        ),
      ),
    );
  }
}
