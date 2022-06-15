import 'dart:convert';

String partnerModelToJson(PartnerModel data) => json.encode(data.toJson());

class PartnerModel {
  String uid = '';
  String partnerContact = '';
  String partnerProfile = '';
  String partnerName = '';
  String partnerEmail = '';
  String partnerPhone = '';

  static final PartnerModel partnerModel = PartnerModel._internal();

  factory PartnerModel() {
    return partnerModel;
  }

  PartnerModel._internal();

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "partnercontact": partnerContact,
        "profileurl": partnerProfile,
        "partnername": partnerName,
        "email": partnerEmail,
        "partnerphone": partnerPhone
      };
}
