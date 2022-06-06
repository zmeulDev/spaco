import 'dart:io';

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
  static final _firebaseStorage = FirebaseStorage.instance.ref();

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

  static Future<String> updatePartnerDataInFirestore(
      File imageFile, String userId) async {
    String res;
    try {
      PartnerModel().profileUrl =
          await uploadPartnerImageToStorage(imageFile, userId);
      await partnerRef.doc(PartnerModel().uid).update(PartnerModel().toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  static Future<String> updatePartnerDataInFirestoreWithoutImage(
      String userId) async {
    String res;
    try {
      await partnerRef.doc(PartnerModel().uid).update(PartnerModel().toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  static Future<String> uploadPartnerImageToStorage(
      File imageFile, String userId) async {
    var url;

    try {
      Reference storageReference = _firebaseStorage.child("partners/${userId}");
      UploadTask storageUploadTask = storageReference.putFile(imageFile);
      url = await (await storageUploadTask.whenComplete(() => true))
          .ref
          .getDownloadURL();
      return url;
    } catch (e) {
      // Helper.showSnack(, e.toString());
      print(e.toString());
    }
    return url;
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
}
