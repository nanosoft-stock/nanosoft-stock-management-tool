import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool kIsLinux = false;
String userName = "";
Color kPrimaryBackgroundColor = Colors.black12;
Color kSecondaryBackgroundColor = Colors.white38;
Color kTertiaryBackgroundColor = Colors.white;
Color kCheckboxCheckedColor = Colors.purple.withOpacity(0.9);
Color kCursorColor = const Color(0xFF333333);
Color kInputFieldFillColor = const Color(0xEEE8DEF8);
Color kButtonBackgroundColor = const Color(0xFFE8DEF8);
TextStyle kLabelTextStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
  ),
);

TextStyle kButtonTextStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  ),
);

BorderRadius kBorderRadius = BorderRadius.circular(10.0);
List<BoxShadow> kBoxShadowList = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 2,
  ),
  BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 2,
  ),
  BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 2,
  ),
  BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 2,
  ),
];
