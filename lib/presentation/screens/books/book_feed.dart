import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/core/firebase/firebase_service.dart';
import 'package:k_books/presentation/screens/books/all_books_screen.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/app_categories.dart';
import 'package:k_books/widgets/fetched_books.dart';
import 'package:k_books/widgets/drawer.dart';
import 'package:k_books/widgets/searched_books.dart';
import 'package:k_books/widgets/recent_books.dart';
import 'package:k_books/widgets/sortedBooks.dart';

class BookFeed extends HookConsumerWidget {
  static String id = "book_viewer";

  const BookFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookViewModel = ref.watch(BookViewModel.provider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await bookViewModel.getCategories();
        await bookViewModel.getAllBooks();
        await bookViewModel.getRecentBooks();
      });
      return;
    }, const []);

    return Scaffold(
      // drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        title: Text(
          "For You",
          style: AppTextStyles.boldedStyle,
        ),
        // leading: Builder(
        //   builder: (context) {
        //     return IconButton(
        //       onPressed: () => Scaffold.of(context).openDrawer(),
        //       icon: const Icon(FlutterRemix.menu_2_line),
        //     );
        //   },
        // ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await bookViewModel.getCategories();
          await bookViewModel.getAllBooks();
          await bookViewModel.getRecentBooks();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                bookViewModel.showCatLoader
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Constants.coolBlue,
                        ),
                      )
                    : const AppCategories(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Library",
                      style: AppTextStyles.smallTextStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AllBooksScreen.id, arguments: "bookStream");
                      },
                      child: Text(
                        "See all",
                        style: AppTextStyles.mutedSmallTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // const FetchedBooks(),
                bookViewModel.showAllLoader
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Constants.coolBlue,
                        ),
                      )
                    : Visibility(
                        visible: bookViewModel.showFilteredBooks,
                        replacement: const FetchedBooks(
                          origin: "all",
                        ),
                        child: const SortedBooks(origin: "all"),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent books",
                      style: AppTextStyles.smallTextStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AllBooksScreen.id,
                            arguments: "orderedBookStream");
                      },
                      child: Text(
                        "See all",
                        style: AppTextStyles.mutedSmallTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                bookViewModel.showRecentLoader == false
                    ? Visibility(
                        visible: bookViewModel.showFilteredBooks,
                        replacement: const FetchedBooks(origin: "recent"),
                        child: const SortedBooks(origin: "recent"),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: Constants.coolBlue,
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
