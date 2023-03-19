import 'package:flutter/material.dart';
import 'package:k_books/core/constants.dart';

class AppTextStyles {
  static const smallTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18);
  static const normalSmallTextStyle =
      TextStyle(color: Colors.black, fontSize: 18);
  static final titleTextStyle = TextStyle(
      color: Constants.coolBlue, fontWeight: FontWeight.bold, fontSize: 22);
  static const mutedSmallTextStyle =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20);
  static const verySmallTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
  static const mutedVerySmallTextStyle =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16);
  static const bigTextStyle =
      TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold);
  static final blurredStyle = TextStyle(
      color: Constants.coolBlue, fontWeight: FontWeight.bold, fontSize: 20);
}
