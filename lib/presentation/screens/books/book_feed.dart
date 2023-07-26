import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/firebase/firebase_service.dart';
import 'package:k_books/presentation/screens/books/all_books_screen.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/app_categories.dart';
import 'package:k_books/widgets/fetched_books.dart';
import 'package:k_books/widgets/drawer.dart';
import 'package:k_books/widgets/filtered_books.dart';
import 'package:k_books/widgets/recent_books.dart';

class BookFeed extends HookWidget {
  static String id = "book_viewer";

  const BookFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    final _fireStore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        //Use methods like getAllBooks etc

        //get categories
        final categoriesCol = await _fireStore.collection("categories").get();
        final categoriesDoc = categoriesCol.docs;
        List<Map<String, dynamic>?>? categories =
            categoriesDoc.map((cat) => cat.data()).toList();
        final cat = categories?[0]?['values'];

        bookViewModel.setCategories(cat);

        //get recent books
        final recentBooksCol = await _fireStore
            .collection("books")
            .orderBy("dateCreated", descending: true)
            .get();

        final recentBooksDocs = recentBooksCol.docs;

        List<Map<String, dynamic>?>? recentBooks =
            recentBooksDocs.map((book) => book.data()).toList();

        bookViewModel.setOrderedBooks(recentBooks);

        //get all books
        final allBooks = await _fireStore.collection("books").get();
        final books = allBooks.docs;

        List<Map<String, dynamic>?>? bookList =
            books.map((book) => book.data()).toList();

        bookViewModel.setFetchedBooks(bookList);
      });
      return;
    }, const []);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(FlutterRemix.menu_2_line),
            );
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(FlutterRemix.more_2_fill))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print("Refreshed");
          final userDoc = await _fireStore.collection("books").get();
          final books = userDoc.docs;

          List<Map<String, dynamic>?>? bookList =
              books.map((book) => book.data()).toList();

          bookViewModel.setOrderedBooks(bookList);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const AppCategories(),

                // if (bookViewModel.showFilteredBooks == true)
                //   Visibility(
                //       visible: bookViewModel.filteredBooks!.isNotEmpty,
                //       replacement: const Center(
                //         child: Text(
                //           "Nothing yet in this category",
                //           style: TextStyle(color: Colors.red),
                //         ),
                //       ),
                //       child: Column(
                //         children: [
                //           const SizedBox(height: 10),
                //           FilteredBooks(bookViewModel.filteredBooks),
                //         ],
                //       )),
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
                const SizedBox(height: 20),
                const FetchedBooks(),
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
                const SizedBox(height: 20),
                const RecentBooks(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
