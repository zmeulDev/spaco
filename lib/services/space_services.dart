import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:spaco/models/space_model.dart';

class SpaceServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreRef = FirebaseFirestore.instance;
  static final userRef = firestoreRef.collection("users");
  static final spaceRef = firestoreRef.collection("spaces");

  static Future<void> storeSpaceDataToFirestore({
    String? uid,
    @required String? spaceName,
    String? spaceEmail,
    String? spaceNoPeople,
    String? spaceTV,
    String? spaceWhiteBoard,
    String? spaceAirConditioning,
    String? spaceImage1,
    String? spaceImage2,
    String? spaceImage3,
    String? spaceImage4,
    String? spaceImage5,
    String? spaceIsFavorite,
    String? spaceIsMain,
    String? spaceStatus,
    String? spaceWifi,
  }) async {
    try {
      SpaceModel().uid = uid ?? '';
      SpaceModel().spaceName = spaceName ?? '';
      SpaceModel().spaceEmail = spaceEmail ?? '';
      SpaceModel().spaceNoPeople = spaceNoPeople ?? '';
      SpaceModel().spaceTV = spaceTV ?? '';
      SpaceModel().spaceWhiteBoard = spaceWhiteBoard ?? '';
      SpaceModel().spaceAirConditioning = spaceAirConditioning ?? '';
      SpaceModel().spaceImage1 = spaceImage1 ?? '';
      SpaceModel().spaceImage2 = spaceImage2 ?? '';
      SpaceModel().spaceImage3 = spaceImage3 ?? '';
      SpaceModel().spaceImage4 = spaceImage4 ?? '';
      SpaceModel().spaceImage5 = spaceImage5 ?? '';
      SpaceModel().spaceIsFavorite = spaceIsFavorite ?? '';
      SpaceModel().spaceIsMain = spaceIsMain ?? '';
      SpaceModel().spaceStatus = spaceStatus ?? '';
      SpaceModel().spaceWifi = spaceWifi ?? '';
      await spaceRef.doc().set(SpaceModel().toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<String> updateSpaceDataInFirestore(
      uid,
      spaceNameController,
      spaceEmailController,
      spaceNoPeopleController,
      spaceTVController,
      spaceWhiteBoardController,
      spaceAirConditioningController,
      spaceImage1Controller,
      spaceImage2Controller,
      spaceImage3Controller,
      spaceImage4Controller,
      spaceImage5Controller,
      spaceIsFavoriteController,
      spaceIsMainController,
      spaceStatusController,
      spaceWifiController) async {
    String res;
    try {
      await spaceRef.doc(uid).update({
        "spaceName": spaceNameController.toString(),
        "spaceEmail": spaceEmailController.toString(),
        "spaceNoPeople": spaceNoPeopleController.toString(),
        "spaceTV": spaceTVController.toString(),
        "spaceWhiteBoard": spaceWhiteBoardController.toString(),
        "spaceAirConditioning": spaceAirConditioningController.toString(),
        "spaceImage1": spaceImage1Controller.toString(),
        "spaceImage2": spaceImage2Controller.toString(),
        "spaceImage3": spaceImage3Controller.toString(),
        "spaceImage4": spaceImage4Controller.toString(),
        "spaceImage5": spaceImage5Controller.toString(),
        "spaceIsFavorite": spaceIsFavoriteController.toString(),
        "spaceIsMain": spaceIsMainController.toString(),
        "spaceStatus": spaceStatusController.toString(),
        "spaceWifi": spaceWifiController.toString(),
      });
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    print(res);
    return res;
  }

  static Future<void> favSpace(doc, String spaceIsFavorite) async {
    return spaceRef.doc(doc).update(
      {'spaceIsFavorite': '$spaceIsFavorite'},
    );
  }

  static Future<void> mainSpace(doc, String spaceIsMain) async {
    return spaceRef.doc(doc).update(
      {'spaceIsMain': '$spaceIsMain'},
    );
  }

  static Future<void> deleteSpace(doc) async {
    return spaceRef.doc(doc).delete();
  }

  static Future<void> deleteSpaceImage(String ref) async {
    await FirebaseStorage.instance.refFromURL(ref).delete();
  }

  static Future<String> uploadSpaceImageToFirebase(image) async {
    final _random = new Random();
    final String fileName = String.fromCharCodes(
        List.generate(30, (index) => _random.nextInt(33) + 89));
    String url;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('spaces/$fileName');
    TaskSnapshot snapshot = await firebaseStorageRef.putFile(image);
    if (snapshot.state == TaskState.success) {
      url = await snapshot.ref.getDownloadURL();
    } else {
      print('Error from image repo ${snapshot.state.toString()}');
      throw ('This file is not an image');
    }
    return url;
  }
}
