import 'dart:convert';

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
  String uid = '';
  String bookingContact = '';
  String bookingProfile = '';
  String bookingName = '';
  String bookingEmail = '';
  String bookingPhone = '';

  static final BookingModel bookingModel = BookingModel._internal();

  factory BookingModel() {
    return bookingModel;
  }

  BookingModel._internal();

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "bookingcontact": bookingContact,
        "profileurl": bookingProfile,
        "bookingname": bookingName,
        "bookingemail": bookingEmail,
        "bookingphone": bookingPhone
      };
}
