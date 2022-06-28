import 'dart:convert';

String roomModelToJson(RoomModel data) => json.encode(data.toJson());

class RoomModel {
  String uid = '';
  String partnerContact = '';
  String partnerProfile = '';
  String partnerName = '';
  String partnerEmail = '';
  String partnerPhone = '';

  static final RoomModel roomModel = RoomModel._internal();

  factory RoomModel() {
    return roomModel;
  }

  RoomModel._internal();

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "partnercontact": partnerContact,
    "profileurl": partnerProfile,
    "partnername": partnerName,
    "partneremail": partnerEmail,
    "partnerphone": partnerPhone
  };
}
