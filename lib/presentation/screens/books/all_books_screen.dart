import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/all_books.dart';

class AllBooksScreen extends HookWidget {
  static String id = "all_books_screen";

  const AllBooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    final String origin = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All books"),
        elevation: 0,
        backgroundColor: Constants.coolBlue,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: AllBooks(
          books: origin == "bookStream"
              ? bookViewModel.fetchedBooks
              : bookViewModel.orderedBooks),
    );
  }
}
