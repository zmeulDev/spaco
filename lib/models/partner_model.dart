import 'dart:convert';

String partnerModelToJson(PartnerModel data) => json.encode(data.toJson());

class PartnerModel {
  String uid = '';
  String profileUrl = '';
  String partnerName = '';
  String email = '';

  static final PartnerModel partnerModel = PartnerModel._internal();

  factory PartnerModel() {
    return partnerModel;
  }

  PartnerModel._internal();

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "profileurl": profileUrl,
        "partnername": partnerName,
        "email": email,
      };
}
