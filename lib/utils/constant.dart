import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF231f20);
const secondaryColor = Color(0xFFFFFFFF);
const tertiaryColor = Color(0xFFDC4405);
const fourthColor = Color(0xFFF89248);
const fifthColor = Color(0xFFF3EFE1);

// admin colors
const kashmirColor = Color(0xFF4D668B);
const ironColor = Color(0xFFE0E3E4);

// booking colors
const purpleColor = Color(0xFF75448C);
const greenColor = Color(0xFF1E7167);
const blueColor = Color(0xFF348598);

var style1 = GoogleFonts.poppins(
  fontSize: 22.0,
  color: primaryColor,
  fontWeight: FontWeight.bold,
  wordSpacing: 1,
  letterSpacing: 0.5,
);
var style2 = GoogleFonts.poppins(
  fontSize: 18.0,
  color: primaryColor,
  wordSpacing: 0.5,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.5,
);
var style3 = GoogleFonts.poppins(
  fontSize: 12.0,
  color: primaryColor,
  wordSpacing: 0.5,
  letterSpacing: 0.5,
);

var styleTos = GoogleFonts.poppins(
  fontSize: 12.0,
  color: primaryColor,
  wordSpacing: 0.5,
  letterSpacing: 0.5,
);

var styleVisitorsInside = GoogleFonts.poppins(
  fontSize: 12.0,
  color: tertiaryColor,
  wordSpacing: 0.5,
  letterSpacing: 0.5,
);

var styleVisitorsHours = GoogleFonts.poppins(
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
