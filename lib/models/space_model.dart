import 'dart:convert';

String spaceModelToJson(SpaceModel data) => json.encode(data.toJson());

class SpaceModel {
  String uid = '';
  String spaceName = '';
  String spaceEmail = '';
  String spaceNoPeople = '';
  String spaceTV = '';
  String spaceWhiteBoard = '';
  String spaceAirConditioning = '';
  String spaceImage1 = '';
  String spaceImage2 = '';
  String spaceImage3 = '';
  String spaceImage4 = '';
  String spaceImage5 = '';
  String spaceIsFavorite = '';
  String spaceIsMain = '';
  String spaceStatus = '';
  String spaceWifi = '';

  static final SpaceModel spaceModel = SpaceModel._internal();

  factory SpaceModel() {
    return spaceModel;
  }

  SpaceModel._internal();

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "spaceName": spaceName,
        "spaceEmail": spaceEmail,
        "spaceNoPeople": spaceNoPeople,
        "spaceTV": spaceTV,
        "spaceWhiteBoard": spaceWhiteBoard,
        "spaceAirConditioning": spaceAirConditioning,
        "spaceImage1": spaceImage1,
        "spaceImage2": spaceImage2,
        "spaceImage3": spaceImage3,
        "spaceImage4": spaceImage4,
        "spaceImage5": spaceImage5,
        "spaceIsFavorite": spaceIsFavorite,
        "spaceIsMain": spaceIsMain,
        "spaceStatus": spaceStatus,
        "spaceWifi": spaceWifi,
      };
}
