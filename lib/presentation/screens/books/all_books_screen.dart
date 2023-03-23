import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/core/firebase/firebase_service.dart';
import 'package:k_books/widgets/all_books.dart';

class AllBooksScreen extends HookWidget {
  static String id = "all_books_screen";

  const AllBooksScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All books"),
        elevation: 0,
        backgroundColor: Constants.coolBlue,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: const AllBooks(),
    );
  }
}
