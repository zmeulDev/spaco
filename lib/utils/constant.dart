import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  // https://coflutter.com/flutter-how-to-get-screen-width-and-height/
  return MediaQuery.of(context).size.height;
}

const appBckColor = Color(0xFFE3EDF2);

const primaryColor = Color(0xFF0A0D25);
const secondaryColor = Color(0xFFFFFFFF);
const tertiaryColor = Color(0xFF4E7D96);
const fourthColor = Color(0xFF9FC9DD);
const fifthColor = Color(0xFFFF844B);

// alerts
const colorMsgDefault = Color(0xFF1D2630);
const colorMsgSuccess = Color(0xFF4E7D96);
const colorMsgWarning = Color(0xFFf39c12);
const colorMsgFail = Color(0xFFe74c3c);

// TODO:  refactor bellow code
// admin colors
const kashmirColor = Color(0xFF4D668B);
const ironColor = Color(0xFFE0E3E4);

// booking colors
const purpleColor = Color(0xFF75448C);
const greenColor = Color(0xFF1E7167);
const blueColor = Color(0xFF348598);

var style1 = GoogleFonts.openSans(
  fontSize: 22.0,
  color: primaryColor,
  fontWeight: FontWeight.bold,
  wordSpacing: 1,
  letterSpacing: 0.5,
);
var style2 = GoogleFonts.openSans(
  fontSize: 18.0,
  color: primaryColor,
  wordSpacing: 0.5,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.5,
);
var style3 = GoogleFonts.openSans(
  fontSize: 12.0,
  color: primaryColor,
  wordSpacing: 0.5,
  letterSpacing: 0.5,
);

var styleTos = GoogleFonts.openSans(
  fontSize: 12.0,
  color: primaryColor,
  wordSpacing: 0.5,
  letterSpacing: 0.5,
);

var styleVisitorsInside = GoogleFonts.openSans(
  fontSize: 12.0,
  color: tertiaryColor,
  wordSpacing: 0.5,
  letterSpacing: 0.5,
);

var styleVisitorsHours = GoogleFonts.openSans(
  fontSize: 12.0,
  color: secondaryColor,
  fontWeight: FontWeight.bold,
  wordSpacing: 0.5,
  letterSpacing: 0.5,
);

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
