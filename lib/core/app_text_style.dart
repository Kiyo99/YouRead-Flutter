import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/core/constants.dart';

class AppTextStyles {
  static final plainTextStyle = GoogleFonts.nunito();
  static final expGStyle = GoogleFonts.nunito(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18);
  static final smallTextStyle = GoogleFonts.nunito(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18);
  static final boldedStyle = GoogleFonts.nunito(fontWeight: FontWeight.bold);
  static final normalSmallTextStyle =
      GoogleFonts.nunito(color: Colors.black, fontSize: 16);
  static final titleTextStyle = GoogleFonts.nunito(
      color: Constants.coolBlue, fontWeight: FontWeight.bold, fontSize: 22);
  static final mutedSmallTextStyle = GoogleFonts.nunito(
      color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16);
  static final verySmallTextStyle = GoogleFonts.nunito(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
  static final mutedVerySmallTextStyle = GoogleFonts.nunito(
      color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16);
  static final bigTextStyle = GoogleFonts.nunito(
      color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold);
  static final blurredStyle = GoogleFonts.nunito(
      color: Constants.coolBlue, fontWeight: FontWeight.bold, fontSize: 20);
}
