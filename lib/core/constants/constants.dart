import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool kIsLinux = false;
String userName = "";
String categoryIdUid = "";
String itemIdUid = "";
String containerIdUid = "";
String warehouseLocationIdUid = "";

Color kPrimaryBackgroundColor = const Color(0xFFE0DCDF); // Colors.black12;
Color kSecondaryBackgroundColor = const Color(0x61FFFFFF);
Color kTertiaryBackgroundColor = const Color(0xFFFFFFFF);
Color kCheckboxCheckedColor = const Color(0xFF9A3DF1);
Color kCursorColor = const Color(0xFF333333);
Color kInputFieldFillColor = const Color(0xEEE8DEF8);
Color kDropdownMenuFillColor = const Color(0xFFF3EDF7);
Color kButtonTextColor = const Color(0xFF6750A4);
Color kButtonBackgroundColor = const Color(0xFFE8DEF8);
Color kPassBackgroundColor = const Color(0xFFCCFFDD);
Color kPassForegroundColor = const Color(0xFF208441);
Color kFailBackgroundColor = const Color(0xFFFFCBDD);
Color kFailForegroundColor = const Color(0xFF981F48);
Color kSuccessSnackBarColor = const Color(0xFF66BB6A);
Color kErrorSnackBarColor = const Color(0xFFEF5350);

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

TextStyle kTableHeaderTextStyle = GoogleFonts.lato(
  textStyle: const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
  ),
);

TextStyle kTableValueTextStyle = GoogleFonts.lato();

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
