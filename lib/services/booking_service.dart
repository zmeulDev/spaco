import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:spaco/models/booking_model.dart';

class BookingServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreRef = FirebaseFirestore.instance;
  static final userRef = firestoreRef.collection("users");
  static final bookingRef = firestoreRef.collection("bookings");

  static Future<void> uploadBookingDataToFirestore({
    String? uid,
    String? bookingContact,
    String? bookingProfile,
    @required String? bookingName,
    String? bookingEmail,
    String? bookingPhone,
  }) async {
    try {
      BookingModel().uid = uid ?? '';
      BookingModel().bookingContact = bookingContact ?? '';
      BookingModel().bookingProfile = bookingProfile ?? '';
      BookingModel().bookingName = bookingName ?? '';
      BookingModel().bookingEmail = bookingEmail ?? '';
      BookingModel().bookingPhone = bookingPhone ?? '';
      await bookingRef.doc().set(BookingModel().toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<String> updateBookingDataInFirestore(
      uid,
      bookingContactController,
      bookingNameController,
      bookingEmailController,
      bookingPhoneController) async {
    String res;
    try {
      await bookingRef.doc(uid).update({
        "bookingcontact": bookingContactController,
        "bookingname": bookingNameController,
        "bookingemail": bookingEmailController,
        "bookingphone": bookingPhoneController
      });
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  static Future<void> favBooking(doc, String isFav) async {
    return bookingRef.doc(doc).update(
      {'isFav': isFav},
    );
  }

  static Future<void> mainBooking(doc, String isMain) async {
    return bookingRef.doc(doc).update(
      {'isMain': isMain},
    );
  }

  static Future<void> deleteBooking(doc) async {
    return bookingRef.doc(doc).delete();
  }

  static Future<void> deleteBookingImage(String ref) async {
    await FirebaseStorage.instance.refFromURL(ref).delete();
  }

  static Future<String> uploadBookingImageToFirebase(image) async {
    final String fileName = DateTime.now().toString();
    String url;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('bookings/$fileName');
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
