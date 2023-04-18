import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';

class BookmarksScreen extends HookWidget {
  static String id = "bookmarks_screen";

  const BookmarksScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Saved Books",
          style: AppTextStyles.boldedStyle,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.coolBlue,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          "Your saved books appear here",
          style: AppTextStyles.titleTextStyle,
        ),
      ),
    );
  }
}
