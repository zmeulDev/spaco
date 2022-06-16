import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:spaco/models/partner_model.dart';

class PartnerServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreRef = FirebaseFirestore.instance;
  static final userRef = firestoreRef.collection("users");
  static final partnerRef = firestoreRef.collection("partners");

  static Future<void> uploadPartnerDataToFirestore({
    String? uid,
    String? partnerContact,
    String? partnerProfile,
    @required String? partnerName,
    String? partnerEmail,
    String? partnerPhone,
  }) async {
    try {
      PartnerModel().uid = uid ?? '';
      PartnerModel().partnerContact = partnerContact ?? '';
      PartnerModel().partnerProfile = partnerProfile ?? '';
      PartnerModel().partnerName = partnerName ?? '';
      PartnerModel().partnerEmail = partnerEmail ?? '';
      PartnerModel().partnerPhone = partnerPhone ?? '';
      await partnerRef.doc().set(PartnerModel().toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<void> favPartner(doc, String isFav) async {
    return partnerRef.doc(doc).update(
      {'isFav': '$isFav'},
    );
  }

  static Future<void> mainPartner(doc, String isMain) async {
    return partnerRef.doc(doc).update(
      {'isMain': '$isMain'},
    );
  }

  static Future<void> deletePartener(doc) async {
    return partnerRef.doc(doc).delete();
  }

  static Future<void> deletePartnerImage(String ref) async {
    await FirebaseStorage.instance.refFromURL(ref).delete();
  }

  static Future<String> uploadPartnerImageToFirebase(image) async {
    final String fileName = DateTime.now().toString();
    String url;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('partners/$fileName');
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
