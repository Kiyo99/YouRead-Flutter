import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/screens/bookmark/bookmarked_books.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class BookmarksScreen extends HookWidget {
  static String id = "bookmarks_screen";

  const BookmarksScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _fireStore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final bookViewModel = useProvider(BookViewModel.provider);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        final userDoc = await _fireStore
            .collection("Users")
            .doc(auth.currentUser?.email)
            .get();

        final userData = userDoc.data();

        bookViewModel.setBookmarkedBooks(userData?['bookmarks']);
      });
      return;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saved Books",
          style: AppTextStyles.boldedStyle,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.coolBlue,
        shadowColor: Colors.transparent,
      ),
      body: bookViewModel.bookmarkedBooks.isEmpty
          ? Center(
              child: Text(
                "Your saved books appear here",
                style: AppTextStyles.titleTextStyle,
              ),
            )
          : BookmarkedBooks(books: bookViewModel.bookmarkedBooks),
    );
  }
}
