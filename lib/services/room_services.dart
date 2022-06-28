import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:spaco/models/partner_model.dart';
import 'package:spaco/models/room_model.dart';

class RoomServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreRef = FirebaseFirestore.instance;
  static final userRef = firestoreRef.collection("users");
  static final roomRef = firestoreRef.collection("rooms");

  static Future<void> uploadRoomDataToFirestore({
    String? uid,
    String? partnerContact,
    String? partnerProfile,
    @required String? partnerName,
    String? partnerEmail,
    String? partnerPhone,
  }) async {
    try {
      RoomModel().uid = uid ?? '';
      RoomModel().partnerContact = partnerContact ?? '';
      RoomModel().partnerProfile = partnerProfile ?? '';
      RoomModel().partnerName = partnerName ?? '';
      RoomModel().partnerEmail = partnerEmail ?? '';
      RoomModel().partnerPhone = partnerPhone ?? '';
      await roomRef.doc().set(RoomModel().toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<String> updateRoomDataInFirestore(
      uid,
      partnerContactController,
      partnerImageUrlController,
      partnerNameController,
      partnerEmailController,
      partnerPhoneController) async {
    String res;
    try {
      await roomRef.doc(uid).update({
        "partnercontact": partnerContactController,
        "profileurl": partnerImageUrlController,
        "partnername": partnerNameController,
        "partneremail": partnerEmailController,
        "partnerphone": partnerPhoneController
      });
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  static Future<void> favRoom(doc, String isFav) async {
    return roomRef.doc(doc).update(
      {'isFav': '$isFav'},
    );
  }

  static Future<void> mainRoom(doc, String isMain) async {
    return roomRef.doc(doc).update(
      {'isMain': '$isMain'},
    );
  }

  static Future<void> deleteRoom(doc) async {
    return roomRef.doc(doc).delete();
  }

  static Future<void> deleteRoomImage(String ref) async {
    await FirebaseStorage.instance.refFromURL(ref).delete();
  }

  static Future<String> uploadRoomImageToFirebase(image) async {
    final String fileName = DateTime.now().toString();
    String url;
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('rooms/$fileName');
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
