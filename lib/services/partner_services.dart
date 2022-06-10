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
    String? profileUrl,
    String? partnerName,
    @required String? email,
  }) async {
    try {
      PartnerModel().uid = uid ?? '';
      PartnerModel().profileUrl = profileUrl ?? '';
      PartnerModel().partnerName = partnerName ?? '';
      PartnerModel().email = email ?? '';
      await partnerRef.doc(uid).set(PartnerModel().toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deletePartener(doc) async {
    return partnerRef.doc(doc).delete();
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
